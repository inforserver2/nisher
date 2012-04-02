class ProductCategoryProductJoinTable < ActiveRecord::Migration
  def change
    create_table :product_categories_products, :id => false do |t|
      t.integer :product_category_id
      t.integer :product_id
    end
  end
end
