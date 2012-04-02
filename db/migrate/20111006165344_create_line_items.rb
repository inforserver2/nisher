class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.float :total_comm_value, default:0
      t.references :product_taste

      t.timestamps
    end
  end
end
