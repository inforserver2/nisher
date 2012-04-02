class CreateComms < ActiveRecord::Migration
  def change
    create_table :comms do |t|
      t.float :value, null:false,default:0
      t.integer :status, null:false,default:0 #{0:free, 1:sending, 2:paid, 2:canceled}
      t.integer :type_id, null:false,default:1 #{1:comm, 2:transfer, 3:credit, 4:order}
      t.integer :comm_type_id
      t.references :order
      t.references :user, null:false
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :payment_id
      t.boolean :blocked, null:false,default:false
      t.timestamp :blocked_at
      t.timestamps
    end
    add_index :comms, :order_id
    add_index :comms, :user_id
  end
end
