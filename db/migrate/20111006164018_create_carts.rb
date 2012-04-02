class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :order_id
      t.timestamps
    end
    add_index :carts, :order_id
  end
end
