#encoding: UTF-8
module BoletosHelper
  def boleto_status status
    case status
    when 0 then "pendente"
    when 1 then "pago"
    else "não informado"
    end
  end
end
