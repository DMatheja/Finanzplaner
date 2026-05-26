class Category < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  
  validates :name, presence: true
  validates :limit, numericality: { greater_than: 0 }, allow_nil: true
  
  def total_spent
    products.includes(:transactions).sum { |p| p.transactions.sum(:amount) }
  end
  
  def over_limit?
    limit.present? && total_spent > limit
  end
end
