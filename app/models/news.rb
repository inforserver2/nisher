class News < ActiveRecord::Base

  validates :email, :email=>:true, :uniqueness=>:true
  before_validation :filter
  before_save :set_blocked

  def filter
    self.email=email.downcase
  end

  def set_blocked
    if blocked_changed? && blocked_was==false && blocked==true
      self.blocked_at=Time.now
    elsif blocked_changed? && blocked==false
      self.blocked_at=nil
    end
  end

end
