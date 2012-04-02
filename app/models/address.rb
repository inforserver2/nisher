class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :country

  validates_presence_of :street_name, :number, :neighborhood, :city_name, :state_name, :zip, on: :update
  validates_numericality_of :country_id, on: :update

end
