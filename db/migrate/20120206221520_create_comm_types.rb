class CreateCommTypes < ActiveRecord::Migration
  def change
    create_table :comm_types do |t|
      t.string :name
      t.boolean :show, default:true

      t.timestamps
    end
  end
end
