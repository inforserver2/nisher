class Contact < ActiveRecord::Base
  validates :sponsor_id, :numericality=>:true
  validates :name, :subject, :message, :email,:presence=>:true
  validates :email, :email=>:true

  attr_accessible :name,:subject, :message, :email, :as=>:guest
end
