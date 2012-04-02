#encoding: UTF-8
module UsersHelper

  def tipo_cliente tipo
    case tipo
    when 1 then "consumo"
    when 2 then "negócios"
    else "não informado"
    end
  end

  def expires_at date
    if date.nil?
      "Ainda não informado"
    else
      date.to_s_br
    end
  end

  def my_plan id
    case id
    when 17 then "Distribuidor 1"
    when 18 then "Distribuidor 2"
    when 19 then "Distribuidor 3"
    else
      "Ainda não informado"
    end
  end

  def tipo_pessoa tipo
    case tipo
    when 1 then "física"
    when 2 then "jurídica"
    else "não informado"
    end
  end

  def sexo_pessoa tipo
    case tipo
    when 1 then "masculino"
    when 2 then "feminino"
    else "não informado"
    end
  end

  def origem_pessoa tipo
    var1=tipo.to_i
    obj=User.comes_from_types.find{|i| i[:id]==var1}
    return "não informado" if obj.nil?
    obj[:name]
  end

  def user_status status
    case status
    when 0 then "pendente"
    when 1 then "ativo"
    when 2 then "inativo"
    when 3 then "cancelado"
    else
      "não informado"
    end

  end

end
