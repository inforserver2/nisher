class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image
      t.float :price
      t.integer :stock
      t.boolean :prod_valid, default:true
      t.boolean :prod_qualified, default:true
      t.boolean :network_plan, default:false
      t.float :comm_porc, default:100
      t.boolean :visible
      t.text :more
      t.decimal :weight, :default=>0, null:false
      t.integer :length, :default=>0, null:false
      t.integer :width,  :default=>0, null:false
      t.integer :height, :default=>0, null:false

      t.timestamps
    end
  end
end
