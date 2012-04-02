class Prospecto < ActiveRecord::Base
  validates_numericality_of :sponsor_id
  validates :name, presence:true
  validates :email, email:true
end
