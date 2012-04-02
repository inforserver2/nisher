class CreateProspectos < ActiveRecord::Migration
  def change
    create_table :prospectos do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
