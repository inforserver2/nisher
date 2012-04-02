class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :title
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
