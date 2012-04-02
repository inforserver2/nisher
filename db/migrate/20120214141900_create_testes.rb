class CreateTestes < ActiveRecord::Migration
  def change
    create_table :testes do |t|
      t.string :name

      t.timestamps
    end
  end
end
