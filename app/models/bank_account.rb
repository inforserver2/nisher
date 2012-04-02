class BankAccount < ActiveRecord::Base

  belongs_to :user
  belongs_to :bank
  belongs_to :bank_account_type

  validates :bank_id, :bank_account_type_id, :agency, :account, :cpf_owner, :fullname_owner, presence:true, if: :need_validate?

  private

  def need_validate?
    if (agency? || account? || cpf_owner? || fullname_owner?)
      return true
    end
  end

end
