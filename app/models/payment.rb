class Payment < ActiveRecord::Base
  usar_como_dinheiro :value

  has_one :p_bank_account, dependent: :destroy
  belongs_to :user
  has_many :comms

  before_save :set_blocked, :set_closed, :inject_p_bank_account_info
  after_save :make_updates, :emailing_close
  after_create :emailing_creation



  scope :not_blocked, where(blocked:false)

  def update_p_bank_account_info
      build_p_bank_account if p_bank_account.nil?
      if p_bank_account.present? && user.bank_account.present?
        p_bank_account.attributes=user.bank_account.attributes
        p_bank_account.save
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

  def set_closed
    if closed_changed? && closed_was==false && closed==true
      self.closed_at=Time.now
      self.status=1
      comms.update_all(status:2)
    elsif closed_changed? && closed==false
      self.closed_at=nil
    end
  end

  def inject_p_bank_account_info
    if p_bank_account.nil?
      build_p_bank_account
      if user.bank_account.present?
        p_bank_account.attributes=user.bank_account.attributes
      end
    end
  end

  def make_updates
      user.comms.free.update_all(status:1, payment_id:id)
  end

  def emailing_creation
    PaymentMailer.delay.new_payment(self.id)
  end
  def emailing_close
    if closed_changed? && closed_was==false && closed==true
      PaymentMailer.delay.close_payment(self.id)
    end
  end

end
