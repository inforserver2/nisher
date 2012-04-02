class Multiuser < ActiveRecord::Base
  validates_numericality_of :cpfcnpj
  validates_uniqueness_of :cpfcnpj
  before_validation :adjust
  private
  def adjust
    self.cpfcnpj=cpfcnpj.downcase if cpfcnpj_changed?
  end
end
