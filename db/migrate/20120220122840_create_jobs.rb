class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name # name of the job
      t.integer :type_id #{0:automatic, 1:manual}
      t.text :log

      t.timestamps
    end
  end
end
