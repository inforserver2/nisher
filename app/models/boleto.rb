#encoding: UTF-8
class Boleto < ActiveRecord::Base

  attr_accessor :qtd, :start_date
  usar_como_dinheiro :price

  validates :name, presence:true
  validates :email, :email=>:true
  validates :cpfcnpj, presence:true
  validates :qtd, :numericality => :true, on: :create
  validates :price, :numericality => :true
  validates :start_date, :presence => :true, on: :create

  before_create :token_filter
  validate :clean_cpf_cnpj, :cpfcnpj_verifications, :check_price
  before_update :make_changes



  def show_cpfcnpj
    if cpfcnpj.try(:size)==11
      Cpf.new cpfcnpj
    elsif cpfcnpj.try(:size)==14
      Cnpj.new cpfcnpj
    else
      cpfcnpj
    end
  end


  private
  def check_price
    if price <= 0
        errors.add(:price,"inválido")
    end
  end
  def clean_cpf_cnpj
      self.cpfcnpj=cpfcnpj.gsub(/[^0-9]/, "") if cpfcnpj && cpfcnpj_changed?
  end
  def cpfcnpj_verifications
    if cpfcnpj_changed?
      cpf=Cpf.new cpfcnpj
      cnpj=Cnpj.new cpfcnpj
      unless cpf.valido? || cnpj.valido?
        errors.add(:cpfcnpj,"inválido")
      end
    end
  end
  def token_filter
    self.token=SecureRandom.hex(10)
  end
  def make_changes
    if status_changed? && status_was==0 && status==1
      self.closed_at=Time.now
    elsif status_changed? && status_was==1 && status==0
      self.closed_at=nil
    end
  end

end
