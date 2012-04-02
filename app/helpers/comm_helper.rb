#encoding: UTF-8
module CommHelper

  def comm_status status
    case status
    when 0 then "disponível"
    when 1 then "em envio"
    when 2 then "pago"
    when 3 then "cancelado"
    else "nao informado"
    end
  end


  def comm_type type
    case type
    when 1 then "bônus"
    when 2 then "tranferência"
    when 3 then "credito"
    when 4 then "compra"
    else "nao informado"
    end
  end

end
