class LayoutsController < ApplicationController

  def home
    @session=User.new
    render :layout=>"home"
  end

  def content_sidebar
  end

  def content_sidebar
  end

  def content_wide
  end

  def office_sidebar
  end

  def office_wide
  end

end
