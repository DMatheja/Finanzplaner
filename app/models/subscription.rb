class Subscription < ApplicationRecord
  belongs_to :user
  
  enum frequency: { monthly: 0, yearly: 1, weekly: 2 }
  
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :frequency, presence: true
end
