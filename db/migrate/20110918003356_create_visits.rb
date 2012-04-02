class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :user
      t.integer :count, :default=>0

      t.timestamps
    end
    add_index :visits, :user_id
  end
end
