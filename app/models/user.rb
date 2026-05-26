class User < ApplicationRecord
  has_secure_password
  
  enum role: { viewer: 0, user: 1, admin: 2 }
  
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :income, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :goals, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
  def balance
    total_income = income.sum(:amount)
    total_expenses = transactions.sum(:amount)
    total_income - total_expenses
  end
end
