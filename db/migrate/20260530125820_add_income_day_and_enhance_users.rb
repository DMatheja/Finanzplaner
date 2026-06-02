class AddIncomeDayAndEnhanceUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :income_day, :integer, default: 1, comment: "Day of month when income arrives (1-31)"
    add_column :products, :purchased_at, :datetime, comment: "Timestamp when product was marked as purchased"
  end
end
