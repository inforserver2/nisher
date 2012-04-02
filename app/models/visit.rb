class Visit < ActiveRecord::Base
  belongs_to :user
  def inc
    self.count+=1
    self.save
  end
  
end
