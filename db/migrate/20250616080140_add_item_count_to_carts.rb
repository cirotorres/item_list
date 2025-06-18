class AddItemCountToCarts < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :item_count, :integer
  end
end
