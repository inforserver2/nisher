class CreateMultiusers < ActiveRecord::Migration
  def change
    create_table :multiusers do |t|
      t.string :cpfcnpj

      t.timestamps
    end
  end
end
