class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.integer :person_type_id #{1:fisica, 2:juridica}
      t.integer :account_type_id #{1:consumo, 2:negocios}
      t.boolean :network_setup, default:false #{true: pays comms to matrix uplines, false:pays comms to only matrix upline}

      t.string :name, null:false
      t.string :password
      t.integer :status, :default=>0 #{0:pending, 1:active, 2:inactive, 3:suspended}
      t.date :expire_date
      t.string :token

      t.boolean :blocked, null:false,default:false
      t.timestamp :blocked_at

      t.string :person_nick
      t.string :company_nick

      t.string :person_name
      t.string :company_name

      t.string :respons_name
      t.string :respons_cpf

      t.string :cpf
      t.string :cnpj

      t.string :rg
      t.date :birth
      t.string :birthday
      t.integer :gender_id, default:0

      t.string :email1
      t.string :email2

      t.string :phone
      t.string :mobile

      t.boolean :admin, :default=>:false

      t.integer :sponsor_id
      t.integer :sponsored_count, default:0

      t.string :redir_from
      t.integer :comes_from_id
      t.integer :network_plan_id, default:0

      t.string :extra
      t.boolean :fake, default:false
      t.boolean :ignore_rules, default:false  #whats this?
      t.timestamp :last_login
      t.text :properties

      t.timestamps
    end
    add_index :users, :name, unique:true
    add_index :users, [:id,:name,:blocked,:status]
  end
end
