class CreateIncome < ActiveRecord::Migration[7.0]
  def change
    create_table :income do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.datetime :income_date, null: false
      t.timestamps
    end
  end
end
