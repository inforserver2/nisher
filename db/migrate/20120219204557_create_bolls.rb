class CreateBolls < ActiveRecord::Migration
  def change
    create_table :bolls do |t|
      t.string :name

      t.timestamps
    end
  end
end
