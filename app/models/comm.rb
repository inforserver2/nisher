class Comm < ActiveRecord::Base
  attr_accessor :mailing
  usar_como_dinheiro :value
  belongs_to :order
  belongs_to :user
  belongs_to :receiver, class_name:"User", foreign_key:"to_user_id"
  belongs_to :sender, class_name:"User", foreign_key:"from_user_id"
  belongs_to :comm_type

  before_save :set_blocked
  after_create  :emailing

  scope :not_blocked, where(blocked:false)
  scope :not_inpay, where(payment_id:nil, status:0).not_blocked
  scope :to_pay, where{created_at < Time.now.beginning_of_month} #squeel
  scope :free, not_inpay.to_pay

  def self.credit_for user
    Comm.where(user_id:user.id, blocked:false, status:0, payment_id:nil).pluck(:value).sum
  end

  def self.comm_porcentage_handle level_id, sponsor_plan_id
    case level_id
    when 1
      return 0.18 if sponsor_plan_id==17
      return 0.14 if sponsor_plan_id==18
      return 0.13 if sponsor_plan_id==19
    when 2
      return 0.08 if sponsor_plan_id==17
      return 0.06 if sponsor_plan_id==18
      return 0.05 if sponsor_plan_id==19
    when 3
      return 0.06 if sponsor_plan_id==17
      return 0.06 if sponsor_plan_id==18
      return 0.04 if sponsor_plan_id==19
    when 4
      return 0.04 if sponsor_plan_id==17
      return 0.04 if sponsor_plan_id==18
      return 0.03 if sponsor_plan_id==19
    else
      nil
    end
  end

  def self.setup_comm_porcentage_handle sponsor_plan_id
    case sponsor_plan_id
    when 17 then 0.30
    when 18 then 0.25
    when 19 then 0.20
    else
      nil
    end
  end

  private

  def set_blocked
    if blocked_changed? && blocked_was==false && blocked==true
      self.blocked_at=Time.now
    elsif blocked_changed? && blocked==false
      self.blocked_at=nil
    end
  end

  def emailing
    CommMailer.delay.new_comm(self.id) if mailing.present? && type_id==1
    CommMailer.delay.new_transfer(self.id) if type_id==2
    CommMailer.delay.new_credit(self.id) if type_id==3
    CommMailer.delay.new_order(self.id) if type_id==4
  end

end
