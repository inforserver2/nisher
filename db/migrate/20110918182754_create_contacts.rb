class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :message
      t.integer :sponsor_id

      t.timestamps
    end
  end
end