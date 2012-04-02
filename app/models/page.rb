#encoding: UTF-8
class Page < ActiveRecord::Base
  validates_presence_of :name, :content
  before_destroy :cannot_delete
  private
  def cannot_delete
    if id==1
      raise ArgumentError, "Não é possivel deletar a pagina entitulada #{name}" 
    end
  end  
end
