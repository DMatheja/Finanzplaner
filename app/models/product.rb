# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category
  
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than: 0 }
  
  # Scopes for history and active products
  scope :active, -> { where(status: 'wishlist').or(where(status: 'planned')) }
  scope :purchased_history, -> { where(status: 'purchased').order(purchased_at: :desc) }
  
  # Deduct from user balance when marked as purchased
  after_update :deduct_from_balance, if: proc { |product| product.saved_change_to_status? && product.status == 'purchased' }
  before_update :set_purchased_at, if: proc { |product| product.status_changed?(to: 'purchased') }
  
  def repurchase
    if status == 'purchased'
      deduct_from_balance
      touch(:purchased_at)
    else
      update!(status: 'purchased', purchased_at: Time.current)
    end
  end
  
  private
  
  def set_purchased_at
    self.purchased_at = Time.current
  end
  
  def deduct_from_balance
    user = category.user
    total = price * amount
    user.update(balance: user.balance - total)
  end
end