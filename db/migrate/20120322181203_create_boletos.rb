class CreateBoletos < ActiveRecord::Migration
  def change
    create_table :boletos do |t|
      t.string :name
      t.string :email
      t.float :price, default:0
      t.integer :status, default: 0
      t.string :order_id
      t.string :address1
      t.string :address2
      t.string :cpfcnpj
      t.date :expire_date
      t.datetime :closed_at
      t.string :token

      t.timestamps
    end
    execute <<-SQL
        ALTER SEQUENCE boletos_id_seq RESTART 3;
        ALTER SEQUENCE "boletos_id_seq" INCREMENT BY 2;
    SQL
  end
end
