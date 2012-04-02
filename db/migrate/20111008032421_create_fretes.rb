class CreateFretes < ActiveRecord::Migration
  def change
    create_table :fretes do |t|
      t.string :to_name
      t.string :street_name
      t.string :number
      t.string :neighborhood
      t.string :complement
      t.string :city_name
      t.string :state_name
      t.references :country
      t.string :zip_to
      t.decimal :weight_total, :scale=>3
      t.integer :length_total 
      t.integer :width_total 
      t.integer :height_total 
      t.float :price, :default=>0
      t.text :query
      t.references :frete_type
      t.references :cart
      t.timestamps
    end
    add_index :fretes, :frete_type_id
    add_index :fretes, :country_id
    add_index :fretes, :cart_id
  end
end
