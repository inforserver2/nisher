#encoding: UTF-8
class ApplicationController < ActionController::Base

  ACTIVE_DEBUG = false

  protect_from_forgery
  layout "content_sidebar"

  include ApplicationHelper
  before_filter :subdomain_filter, :set_session_obj, :expire_session_control


private

  def set_session_obj
    unless is_logged?
      @session=User.new
    end
  end

  def subdomain_filter
      url = request.url
      subdomain = params[:name].present? ? params[:name] : request.subdomains.last
     # @sponsor = User.where("(id = ? or name = ?) and status=1 and blocked=false and account_type_id=2", subdomain.to_i, subdomain).first || User.sort #TODO sql
      @sponsor = User.where{((id==subdomain.to_i) | (name==subdomain)) & (status==1) & (blocked==false) & (account_type_id==2)}.first || User.sort


      raise "there is no sponsor for this site" if @sponsor.nil?
      unless subdomain.in? [@sponsor.name,@sponsor.id.to_s]
        domain=URI.parse(root_url(:subdomain=>@sponsor.name))
        domain.path=request.path if params[:name].blank?
        queries=request.query_string.split("&")
        queries=queries.delete_if{|x| x.include? "redir"}
        queries<<"redir=true&redir_from=#{subdomain}"
        domain.query=queries.join("&") if params[:name].blank?

        redirect_to params[:name].present? ? root_url(:subdomain=>@sponsor.name, :redir=>true,:redir_from=>params[:name]) : domain.to_s

      else

        if subdomain==@sponsor.id.to_s
          domain=URI.parse(root_url(:subdomain=>@sponsor.name))
          domain.path=request.path
          redirect_to domain.to_s
        end


        if params[:redir].present? && params[:redir_from].blank?
          params[:redir_from]="none"
        end

        unless session[:sponsor]
          @sponsor.visit.inc
          session[:sponsor]={id:@sponsor.id, redir_from: params[:redir_from]}
        end
        session[:sponsor]={id:@sponsor.id, redir_from: params[:redir_from]} if params[:redir].present? && params[:redir_from].present?
      end

  end

  def expire_session_control
    if is_logged? && session[:logged].any? && session[:logged][:expire_at] > Time.now
      update_expire_time
    elsif is_logged? && session[:logged].any? && session[:logged][:expire_at] < Time.now
      unlog_user "A sessão expirou!", :sign_in
    end
  end

  def require_login
    unless is_logged?
      flash[:notice]="Faça seu login"
      redirect_to :sign_in
    end
  end




end
