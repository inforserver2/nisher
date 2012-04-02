#encoding: UTF-8
module BankAccountHelper

  def bank_account_type type
    case type
    when 1 then "poupança"
    when 2 then "corrente"
    else "nao informado"
    end
  end

end
