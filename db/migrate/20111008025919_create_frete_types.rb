class CreateFreteTypes < ActiveRecord::Migration
  def change
    create_table :frete_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
