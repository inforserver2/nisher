class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :user
      t.references :bank
      t.references :bank_account_type
      t.string :agency
      t.string :account
      t.string :fullname_owner
      t.string :cpf_owner
      t.string :extra
      t.timestamps
    end
    add_index :bank_accounts, :user_id
    add_index :bank_accounts, :bank_id
    add_index :bank_accounts, :bank_account_type_id
  end
end
