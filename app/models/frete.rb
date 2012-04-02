#encoding: UTF-8
class Frete < ActiveRecord::Base

  attr_accessor :calculate_frete


  serialize :query, Array
  belongs_to :frete_type
  belongs_to :cart
  belongs_to :country
  after_initialize :country_select

  attr_accessible :to_name, :street_name, :number, :neighborhood, :complement, :city_name, :state_name, :country_id, :zip_to, :as=>:buyer

  validates :to_name, :street_name, :number, :neighborhood, :city_name, :state_name, :country_id, :zip_to, :presence=>true, :on=>:update
  validate :fill_dependencies, if: "calculate_frete==true"
  validate :serialize_external_query_info, if: "calculate_frete==true"


#  validate :must_have_frete_results, :must_check_price_info
  #
  def sedex_price
    query.last[:sedex].valor.real_contabil
  end
  def pac_price
    query.last[:pac].valor.real_contabil
  end

  def frete_is_ok?
    valid=false
    if country_id==29
      if query.any?
        if frete_type_id==1
          valid=query.last[:pac].sucesso?
        elsif frete_type_id==2
          valid=query.last[:sedex].sucesso?
        end
      end
    elsif (country_id.is_a? Numeric) && country_id!=29
      valid=true
    end
    valid
  end

  private

  def fill_dependencies
    if calculate_frete==true
      self.weight_total = cart.total_weight
      self.length_total = cart.final_length.ceil
      self.width_total = cart.final_width.ceil
      self.height_total = cart.final_height.ceil
    end
  end

  def country_select
    self.country_id ||= 29
  end


  def serialize_external_query_info
    self.zip_to = 0 if zip_to.blank?
    if calculate_frete==true
      if country_id==29 && zip_to.present?
        frete = Correios::Frete::Calculador.new :cep_origem => CFG["frete_cep_origem"],
          :cep_destino => zip_to,
          :peso => weight_total,
          :comprimento => length_total,
          :largura => width_total,
          :altura => height_total

        begin
          servicos = frete.calcular :sedex, :pac
          if servicos[:sedex].erro?
            errors.add(:zip_to, "destino inválido") if servicos[:sedex].msg_erro.match("CEP").present?
          end
          self.query=[frete, servicos]
        rescue
          errors.add(:base, "O sistema de cálculo de fretes esta indisponível no momento, tente mais uma vez ou mais tarde!")
        end

      else
        self.query=nil
        self.frete_type_id=3
      end
    end

  end

  def must_check_price_info
    if country_id==29 && @servico.try(:sucesso?)
      if price <= 0
        errors.add(:price, "ocorreu alguma falha de comunicação e o servidor não pode entregar o valor do frete, tente novamente ou entre em contato conosco para atualizarmos o valor do frete manualmente.")
      end
    end
  end

end
