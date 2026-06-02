# app/models/user.rb
require Rails.root.join('lib/security_dictionary').to_s

class User < ApplicationRecord
  has_secure_password
  enum :role, { admin: 0, user: 1, viewer: 2, test_admin: 3 }

  has_many :categories, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :income_day, presence: true, inclusion: { in: 1..31 }
  validate :password_not_in_dictionary, if: -> { password.present? }
  
  after_create :create_default_category
  
  # Rate limiting
  MAX_ATTEMPTS = 3
  LOCKOUT_DURATION = 15.minutes
  
  def locked_out?
    return false unless rate_limit_enabled
    locked_until.present? && locked_until > Time.current
  end
  
  def increment_failed_attempts
    update(failed_attempts: failed_attempts + 1)
    if rate_limit_enabled && failed_attempts >= MAX_ATTEMPTS
      update(locked_until: Time.current + LOCKOUT_DURATION)
    end
  end
  
  def reset_attempts
    update(failed_attempts: 0, locked_until: nil)
  end
  
  def current_time
    test_admin? ? Time.current + (time_offset || 0).days : Time.current
  end
  
  def can_time_travel?
    test_admin?
  end

  def advance_time_by_days!(days = 1)
    old_time = current_time
    increment!(:time_offset, days)
    credit_monthly_income_if_due!(old_time + days.days)
  end

  def credit_monthly_income_if_due!(new_time)
    return unless income_day.present? && income.present?
    return unless new_time.day == income_day

    update!(balance: (balance || 0) + income)
  end

  def password_not_in_dictionary
    return if password.blank?

    normalized_password = password.downcase.strip
    if SecurityDictionary::WORDS.any? { |word| word.downcase == normalized_password }
      errors.add(:password, 'is not secure enough because it matches a common dictionary word')
    end
  end
  
  private
  
  def create_default_category
    categories.create!(name: "Sonstiges", limit: 0) unless categories.exists?(name: "Sonstiges")
  end
end