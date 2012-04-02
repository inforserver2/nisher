class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :price, default: 0
      t.integer :status, default: 0 #{0:pending, 1:paid, 2:canceled}
      t.string :token
      t.references :user
      t.boolean :blocked, null:false,default:false
      t.timestamp :blocked_at
      t.text :extra
      t.boolean :closed
      t.datetime :closed_at
      t.boolean :paid_with_money, default:true

      t.timestamps
    end
    add_index :orders, :user_id
  end
end
