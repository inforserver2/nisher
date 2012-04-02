class AddBuyToProducts < ActiveRecord::Migration
  def change
    add_column :products, :buy, :boolean, :default=>true
  end
end
