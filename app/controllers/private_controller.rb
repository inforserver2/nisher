class PrivateController < ApplicationController
  before_filter :require_login 
  layout "content_office_sidebar"
  def index
    
  end
  
end
