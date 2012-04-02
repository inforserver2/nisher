#encoding: UTF-8
module PaymentsHelper

  def payment_status status
    case status
    when 0 then "a enviar"
    when 1 then "enviado"
    when 2 then "pendente"
    when 3 then "cancelado"
    else "nao informado"
    end
  end

end
