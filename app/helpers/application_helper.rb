#encoding: UTF-8
module ApplicationHelper
  def current_user
    User.where(:id=>session[:logged][:user][:id], :token=>session[:logged][:user][:token]).first if is_logged?
  end

  def current_master
    User.where(:id=>session[:logged][:master][:id], :token=>session[:logged][:master][:token]).first if is_logged?
  end

  def is_logged?
    session[:logged].present?
  end

  def is_admin?
    current_user.admin?
  end

  def is_sublogged?
    if session[:logged].present?
      session[:logged][:user]!=session[:logged][:master]
    end
  end

  def log_user user, flash_message=nil, redirection_path=nil
    user={id:user.id, token:user.token}
    master=user.dup
    session[:logged]={
      user: user,
      master:master,
      created_at: Time.now
    }
    update_expire_time
    flash[:success]=flash_message if flash_message
    redirect_to redirection_path if redirection_path
  end

  def unlog_user flash_message=nil, redirection_path=nil
    flash[:success]=flash_message
    session[:logged]=nil if is_logged?
    redirect_to redirection_path
  end

  def update_expire_time
    session[:logged][:expire_at]=Time.now+CFG['expiration_time'].minutes
  end

  def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
  end

  def clear_cart
      session[:cart_id] = nil
  end

  def empty_cart
      unless session[:cart_id].blank?
       cart=Cart.find(session[:cart_id])
       cart.line_items.clear
      end
  end

  def username_for_subdomain user
    if user.account_type_id==2
      return user.name
    end
    CFG["root_username"]
  end

  def get_site user
    protocol="http://"
    subdomain=user.name
    domain=CFG['domain']
    host=[subdomain, domain].join(".")
    url=[protocol, host].join
    url
  end

  def get_site_show user
    protocol="http://"
    subdomain=user.name
    domain=CFG['domain']
    path="/renda"
    host=[subdomain, domain].join(".")
    url=[protocol, host, path].join
    url
  end

  def get_site_link user, options
    url=get_site user
    options[:content] = url unless options[:content].present?
    options[:target] = "_self" unless options[:target].present?
    raw "<a href='#{url}' target='#{options[:target]} '>#{options[:content]}</a>"
  end

  def boo v
    case v
    when false then "não"
    when true then "sim"
    else
      "não informado"
    end
  end


end
