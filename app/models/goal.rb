class Goal < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :target_date, presence: true
  
  def months_to_target
    return 0 if user.balance >= target_amount
    amount_needed = target_amount - user.balance
    monthly_saved = user.income.where("income_date >= ?", 1.month.ago).sum(:amount) / 1.0
    return Float::INFINITY if monthly_saved <= 0
    (amount_needed / monthly_saved).ceil
  end
end
