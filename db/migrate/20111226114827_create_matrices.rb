class CreateMatrices < ActiveRecord::Migration
  def change
    create_table :matrices do |t|
      t.references :user
      t.integer :upline_id, null:false
      t.integer :downlines_count, default:0
      t.integer :level1, default:0
      t.integer :level2, default:0
      t.integer :level3, default:0
      t.integer :level4, default:0
      t.integer :level5, default:0
      t.integer :level6, default:0
      t.integer :level7, default:0
      t.integer :level8, default:0

      t.timestamps
    end
    add_index :matrices, :user_id
    add_index :matrices, :upline_id
    add_index :matrices, [:user_id,:upline_id]

  end
end
