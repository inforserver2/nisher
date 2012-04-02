class PBankAccount < ActiveRecord::Base
  belongs_to :bank
  belongs_to :bank_account_type
  belongs_to :payment
end
