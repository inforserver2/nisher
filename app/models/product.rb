#encoding: UTF-8
class Product < ActiveRecord::Base
  NPS_IDS=[17,18,19] # all ids of visible network products must be in here
  usar_como_dinheiro :price
  mount_uploader :image, ProductImageUploader
  has_many :line_items
  has_many :product_tastes
  before_destroy :ensure_not_referenced_by_any_line_item

  has_and_belongs_to_many :product_categories
  validates :title, :presence=>true
  validates :comm_porc, :inclusion => { :in => 0..100,
    :message => "%{value} deve ser entre 0 e 100" }
  validates :image,
    :file_size => {
      :maximum => 1.megabytes.to_i
    }
  validate :ensure_has_a_category_assoc
  validate :ensure_price_has_the_right_value

  after_create :cleanup_fragments
  after_update :cleanup_fragments
  after_destroy :cleanup_fragments

  scope :visibles, where(visible:true)
  scope :network_products, where(network_plan:true).visibles

  def to_param
    "#{id}-#{title.remover_acentos.parameterize.downcase}"
  end

  def self.network_products_ids
    NPS_IDS
  end


  def cleanup_fragments
      ActionController::Base.new.expire_fragment("site_menu_products")
      ActionController::Base.new.expire_fragment("site_bottom1")
      ActionController::Base.new.expire_fragment("site_product_list")
      ActionController::Base.new.expire_fragment("site_home_banners")
      ActionController::Base.new.expire_fragment("site_kit1")
    end

  private

  def ensure_has_a_category_assoc
    if product_category_ids.empty?
      errors.add(:product_category_ids, "selecione no mínimo uma categoria")
    end
  end

  def ensure_price_has_the_right_value
    errors.add(:price, "deve ser maior ou igual a 0") if price<0
  end

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'este produto não pode ser deletado porque pertence à itens em carrinhos de compras')
        return false
      end
    end



end
