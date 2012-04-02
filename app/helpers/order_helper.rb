module OrderHelper

  def order_status status
    case status
    when 0 then "pendente"
    when 1 then "pago"
    when 2 then "cancelado"
    else "nao informado"
    end
  end


  def order_way type
    case type
      when true then "moeda nacional"
      when false then "permuta"
      else "nao informado"
    end
  end



end
