#encoding: UTF-8
class LineItem < ActiveRecord::Base
  attr_accessor :weight_loss
  belongs_to :product
  belongs_to :product_taste
  belongs_to :cart
  validate :verify_cart_weight_limit

  before_destroy :make_reset

  def total_price
    unit_price * quantity
  end

  def inc
    make_reset
    return true if product_id.in? Product.network_products_ids
    self.quantity+=1
    self.total_comm_value = Cart.calc_comm self.product, self
    self.save
  end

  def dec pid=nil
    if quantity>1
      make_reset
      return true if product_id.in? Product.network_products_ids
      self.quantity-=1
      self.total_comm_value = Cart.calc_comm self.product, self
      self.save validate:false
    end
  end

  def is_qualified_product?
    product.prod_qualified
  end


  private

  def verify_cart_weight_limit
    if self.cart.total_weight+self.product.weight > 30
      errors.add(:weight_loss, "O item não pode ser adicionado a esta compra. O peso total da compra não pode ser superior à 30 kg.")
    end
  end

  def make_reset
    self.cart.reset_query_frete
  end

end
