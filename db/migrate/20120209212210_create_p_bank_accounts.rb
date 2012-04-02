class CreatePBankAccounts < ActiveRecord::Migration
  def change
    create_table :p_bank_accounts do |t|
      t.references :user
      t.references :bank
      t.references :bank_account_type
      t.references :payment
      t.string :agency
      t.string :account
      t.string :fullname_owner
      t.string :cpf_owner
      t.string :extra

      t.timestamps
    end
    add_index :p_bank_accounts, :user_id
    add_index :p_bank_accounts, :bank_id
    add_index :p_bank_accounts, :bank_account_type_id
    add_index :p_bank_accounts, :payment_id
  end
end
