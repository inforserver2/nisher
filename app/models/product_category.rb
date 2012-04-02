#encoding: UTF-8
class ProductCategory < ActiveRecord::Base
  mount_uploader :image, ProductCategoryImageUploader
  has_and_belongs_to_many :products
  before_destroy :ensure_has_no_products_assoc
  validates :title, :presence=>true
  validates :image, 
    :file_size => { 
      :maximum => 1.megabytes.to_i
    } 
  def ident
    ["##{self.class.name.downcase}", id].join("_") if persisted?
  end
  private
  def ensure_has_no_products_assoc
    if products.any?
      raise ArgumentError, "#{title} contem produtos associados portanto não pode ser deletado"
    end
  end
end
