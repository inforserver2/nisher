class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
