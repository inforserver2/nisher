#encoding: UTF-8
module Admin::JobsHelper
  def job_type type_id
    case type_id
    when 0 then "automatico"
    when 1 then "manual"
    else
      "não informado"
    end
  end
end
