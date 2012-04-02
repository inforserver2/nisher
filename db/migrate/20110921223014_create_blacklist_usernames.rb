class CreateBlacklistUsernames < ActiveRecord::Migration
  def change
    create_table :blacklist_usernames do |t|
      t.string :name

      t.timestamps
    end
  end
end
