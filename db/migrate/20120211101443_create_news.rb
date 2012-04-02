class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :email, null:false
      t.boolean :blocked, null:false, default:false
      t.timestamp :blocked_at

      t.timestamps
    end
  end
end
