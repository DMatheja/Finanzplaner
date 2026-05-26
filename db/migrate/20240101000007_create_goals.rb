class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :target_amount, precision: 10, scale: 2, null: false
      t.datetime :target_date, null: false
      t.timestamps
    end
  end
end
