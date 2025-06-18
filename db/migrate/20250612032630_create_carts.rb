class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0  # 0 = active, 1 = completed

      t.timestamps
    end
  end
end
