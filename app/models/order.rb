#encoding: UTF-8
class Order < ActiveRecord::Base


  REMINDER_DATES=[3,10,15]

  attr_accessor :mailing, :closing, :make_comm,:pay_via_credit, :creating, :cart_id, :matrix_button, :gen_cart_seed, :product_id
  usar_como_dinheiro :price

  @cartx=nil


  belongs_to :user
  has_one :cart, dependent: :destroy
  has_many :comms, dependent: :destroy

  scope :not_blocked, where(blocked:false)
  scope :pending, where(status:0).not_blocked

  validates_presence_of :user_id
  validates_numericality_of :status

  before_save :token_filter, :set_bloked_at, :set_closed_at,:on_creation, :close_conditions
  before_destroy :cannot_destroy_filter

  after_save :inject_the_cart,  :emailing




  def description
    "Pedido Nisher: #{id}"
  end

  def toggle_blocked_comms
    comms.each do |comm|
      unless comm.blocked?
        comm.update_attributes({blocked:true}, without_protection:true)
      else
        comm.update_attributes({blocked:false}, without_protection:true)
      end
    end
  end

  def self.get_date_interval from, to
    from=from.to_date
    to=to.to_date
    (from-to).to_i
  end

  def self.reminder_interval_range? day
    day.in? REMINDER_DATES
  end

  def self.reminder_count day
    case day
    when 3 then 1
    when 10 then 2
    when 15 then 3
    else
      0
    end
  end

  private

  def cannot_destroy_filter
    unless status==0
      errors.add(:base,"não é possivel remover esta ordem devido as condições requeridas.")
      false
    end
  end

  def on_creation
      if product_id.present?
          @cartx=Cart.create_cart_seed product_id
          self.price=@cartx.final_price
          self.cart_id=@cartx.id
      end
  end

  def close_conditions


    if closing.present? && (closed_was==true || status_was==1)
      errors.add(:base, "este pedido já encontra-se com pagamento concluído.")
      return false
    elsif closing.present?
      if cart.present?
        tcv=cart.total_comms_value
        mycart=cart
      else
        tcv=@cartx.total_comms_value
        mycart=@cartx
      end

      if pay_via_credit.present?
        credit=Comm.credit_for(user)
        if credit < price
          errors.add(:base, "usuário não têm crédito suficiente para quitar esta fatura via saldo.")
          return false
        else
          self.make_comm=true
          comms.build(value:price-(price*2), user_id:user.id, type_id:4)
        end
      end

      qualified_total_price=mycart.qualified_total_price?
      product_ids=mycart.line_items.pluck(:product_id)
      qualify_question=user.matrix.nil? &&  user.account_type_id==2 && User.cannot_be_any_in_cont?(product_ids)


      self.closed=true
      self.closed_at=Time.now
      self.status=1

      activate_matrix if qualify_question

      if user.matrix.present? && user.account_type_id==2 && qualified_total_price
        self.user.expire_date=((self.user.expire_date || Time.now)+32.days).to_date
        self.user.status=1
      end

      plan_id=User.whats_the_plan? product_ids
      actual_plan_id = user.network_plan_id > 0 ? user.network_plan_id : false
      if actual_plan_id
        self.user.network_plan_id=plan_id if User.cannot_be_any_in_cont?([plan_id]) && plan_id < actual_plan_id
      else
        self.user.network_plan_id=plan_id if User.cannot_be_any_in_cont?([plan_id])
      end

      if make_comm.present? && make_comm != "0"

        if user.account_type_id==1 || (user.account_type_id==2 && user.matrix.nil?)
          if user.redir_from?
            comms.build(value:(tcv*0.10), comm_type_id:10, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
          else
            comms.build(value:(tcv*0.25), comm_type_id:9, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
          end

        elsif user.account_type_id==2 && user.matrix.present?

            if user.network_setup
              l1=user.matrix.upline
              l2=l1.upline
              l3=l2.upline
              l4=l3.upline
              l5=l4.upline
              l6=l5.upline
              l7=l6.upline
              l8=l7.upline
              comms.build(value:(tcv*Comm.comm_porcentage_handle(1,l1.user.network_plan_id)), comm_type_id:1, user_id:l1.user.id, mailing:mailing) if fire_user l1.user
              comms.build(value:(tcv*Comm.comm_porcentage_handle(2,l2.user.network_plan_id)), comm_type_id:2, user_id:l2.user.id, mailing:mailing) if fire_user l2.user
              comms.build(value:(tcv*Comm.comm_porcentage_handle(3,l3.user.network_plan_id)), comm_type_id:3, user_id:l3.user.id, mailing:mailing) if fire_user l3.user
              comms.build(value:(tcv*Comm.comm_porcentage_handle(4,l4.user.network_plan_id)), comm_type_id:4, user_id:l4.user.id, mailing:mailing) if fire_user l4.user
             # comms.build(value:(tcv*0.06), comm_type_id:5, user_id:l5.user.id, mailing:mailing) if fire_user l5.user
             # comms.build(value:(tcv*0.06), comm_type_id:6, user_id:l6.user.id, mailing:mailing) if fire_user l6.user
             # comms.build(value:(tcv*0.06), comm_type_id:7, user_id:l7.user.id, mailing:mailing) if fire_user l7.user
             # comms.build(value:(tcv*0.03), comm_type_id:8, user_id:l8.user.id, mailing:mailing) if fire_user l8.user
            else
              if user.redir_from?
                comms.build(value:(tcv*0.10), comm_type_id:12, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
              else
                if 17.in? product_ids
                  comms.build(value:(tcv*Comm.setup_comm_porcentage_handle(user.sponsor.network_plan_id)), comm_type_id:11, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
                elsif 18.in? product_ids
                  comms.build(value:(tcv*Comm.setup_comm_porcentage_handle(user.sponsor.network_plan_id)), comm_type_id:11, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
                elsif 19.in? product_ids
                  comms.build(value:(tcv*Comm.setup_comm_porcentage_handle(user.sponsor.network_plan_id)), comm_type_id:11, user_id:user.sponsor.id, mailing:mailing) if fire_user user.sponsor
                end
              end
            end

        end
      end

      self.user.network_setup=true if qualify_question
      self.user.save validate:false

    end
  end

  def fire_user user
    user.status==1 && user.blocked==false
  end

  def token_filter
    self.token=SecureRandom.hex(10) unless token.present?
  end

  def set_bloked_at
    if blocked_changed? && blocked_was==false && blocked==true
      self.blocked_at=Time.now
    elsif blocked_changed? && blocked==false
      self.blocked_at=nil
    end
  end

  def set_closed_at
    if closed_changed? && closed==false
      self.closed_at=nil
    end
  end

  def inject_the_cart
    if cart_id.present?
      cart=Cart.find(cart_id)
      cart.update_attributes(order_id:id)
    end
  end

  def emailing
    OrderMailer.delay.new_order(self) if creating.present? && mailing.present?
    OrderMailer.delay.close_order(self) if closing.present? && mailing.present?
  end

  def activate_matrix
      user.create_matrix
  end






end
