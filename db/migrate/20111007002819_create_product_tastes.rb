class CreateProductTastes < ActiveRecord::Migration
  def change
    create_table :product_tastes do |t|
      t.string :name
      t.references :product

      t.timestamps
    end
    add_index :product_tastes, :product_id
  end
end
