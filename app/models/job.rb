class Job < ActiveRecord::Base
  def self.load id
    case id
    when 1 then system("/usr/local/bin/rake auto:cart_clean")
    else
      "nada a executar"
    end
  end
end
