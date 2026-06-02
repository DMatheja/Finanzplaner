class AddTimeOffsetToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :time_offset, :integer
  end
end
