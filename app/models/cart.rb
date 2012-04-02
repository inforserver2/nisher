#encoding: UTF-8
class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  has_one :frete, dependent: :destroy
  belongs_to :order
  accepts_nested_attributes_for :frete
  before_save :load_requisites


  def add_product(product, product_taste_id)
    reset_query_frete
    if User.cannot_be_any_in_cont? [product.id]
      current_item = line_items.find_by_product_id_and_product_taste_id(product.id, product_taste_id)
      if current_item
        current_item.destroy if current_item.product_id != product.id
      else
        current_item = line_items.build(:product_id => product.id, :product_taste_id=>product_taste_id, :unit_price=>product.price)
        current_item.total_comm_value = Cart.calc_comm product, current_item
      end
      product_list=Product.network_products_ids-[product.id]
      line_items.where(product_id:product_list).try(:map,&:destroy) if product_list.any?
    else
      current_item = line_items.find_by_product_id_and_product_taste_id(product.id, product_taste_id)
      if current_item
        current_item.quantity += 1
        current_item.total_comm_value = Cart.calc_comm product, current_item
      else
        current_item = line_items.build(:product_id => product.id, :product_taste_id=>product_taste_id, :unit_price=>product.price)
        current_item.total_comm_value = Cart.calc_comm product, current_item
      end
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def final_price
    a=total_price || 0
    b=self.frete.price || 0
    a+b
  end

  def total_items
    line_items.sum(:quantity)
  end

  def total_weight
    line_items.to_a.sum{ |item| item.quantity * item.product.weight }
  end

  def total_length
    line_items.to_a.sum{ |item| item.quantity * item.product.length }
  end

  def total_width
    v=line_items.to_a.sum{ |item| item.quantity * item.product.width }
  end

  def max_width
    item=line_items.to_a.max{ |item| item.product.width }
    item=item.product.width
    if item < 11
      return 11
    else
      return item
    end

  end

  def total_height
    line_items.to_a.sum{ |item| item.quantity * item.product.height }
  end

  def final_height
    h=the_greather_pack_product.height
    return 2 if h <=0
    h
  end

  def the_greather_pack_product
    line_item=line_items.to_a.max{|item| item.product.width+item.product.height+item.product.length }
    line_item.product
  end

  def final_length
    l=total_length
    if l < 16
      return 16
    elsif l >=16 && l < 90
      return l
    else
      90
    end
  end

  def total_size
    [total_length, total_width, total_height].sum
  end

  def final_width

    length = 90

    line_items.each do |item|
      length -= item.product.length * item.quantity
    end

    if length < 0
      width = max_width * 2
      if width > 50
        return 50
      else
        return width
      end
    else
      return max_width
    end

    return false
  end

  def load_requisites
    self.build_frete unless self.frete.present?
  end
  def reset_query_frete
    self.frete.query=[]
    self.frete.price=nil
    self.frete.save validate:false
  end

  def has_some_item?
    total_items > 0
  end

  def valid_to_order?
    has_some_item? && frete.frete_is_ok?
  end

  def total_comms_value
    line_items.pluck(:total_comm_value).sum
  end

  def has_some_qualified_product?
    line_items.map(&:is_qualified_product?).include? true
  end

  def qualified_total_price?
    total_price>=CFG["min_order_price_to_qualify"]
  end

  def self.calc_comm product, current_item

    v = product.price
    p = product.comm_porc/100
    r1 = v*p
    r2 = r1 * current_item.quantity

  end

  def self.create_cart_seed product_id=1
      product=Product.find(product_id)
      cart = Cart.create
      userx = User.where(id:1).first
      cart.build_frete
      cart.add_product(product, nil)
      cart.frete.to_name = userx.get_name
      cart.frete.street_name = userx.address.street_name
      cart.frete.number = userx.address.number
      cart.frete.neighborhood = userx.address.neighborhood
      cart.frete.city_name = userx.address.city_name
      cart.frete.state_name = userx.address.state_name
      cart.frete.country_id = userx.address.country_id
      cart.frete.zip_to = userx.address.zip
      cart.frete.frete_type_id = 3
      cart.save
      cart
  end

  def self.new_cart_seed userx, product
      cart = Cart.create
      cart.build_frete
      cart.add_product(product, nil)
      cart.frete.to_name = userx.get_name
      cart.frete.street_name = userx.address.street_name
      cart.frete.number = userx.address.number
      cart.frete.neighborhood = userx.address.neighborhood
      cart.frete.city_name = userx.address.city_name
      cart.frete.state_name = userx.address.state_name
      cart.frete.country_id = userx.address.country_id
      cart.frete.zip_to = userx.address.zip
      cart.save
      cart.frete.calculate_frete=true
      cart.save
      cart.frete.update_attributes({frete_type_id:1, price:cart.frete.query.last[:pac].valor}, without_protection:true)
      cart
  end


end
