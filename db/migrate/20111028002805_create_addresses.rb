class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user
      t.string :street_name
      t.string :number
      t.string :neighborhood
      t.string :complement
      t.string :city_name
      t.string :state_name
      t.string :zip
      t.references :country

      t.timestamps
    end
    add_index :addresses, :user_id
    add_index :addresses, :country_id
  end
end
