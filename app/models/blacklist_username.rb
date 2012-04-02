class BlacklistUsername < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  before_validation :adjust
  private
  def adjust
    self.name=name.downcase if name_changed?
  end
end
