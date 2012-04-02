class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, null:false
      t.float :value, null:false,default:0
      t.integer :status, null:false, default: 0 #{0:to send, 1:sent, 2:canceled}
      t.text :obs
      t.boolean :closed, null:false,default:false
      t.timestamp :closed_at
      t.boolean :blocked, null:false,default:false
      t.timestamp :blocked_at

      t.timestamps
    end
    add_index :payments, :user_id
  end
end
