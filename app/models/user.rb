# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  enum :role, { admin: 0, user: 1, viewer: 2 }

  has_many :categories, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
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
end