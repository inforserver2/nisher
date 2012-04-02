#encoding: UTF-8
class SessionsController < ApplicationController

  skip_before_filter :expire_session_control

  def new
    if is_logged?
      flash[:notice]="Usuário já esta logado."
      redirect_to root_path
    end
  end

  def create
    user=User.auth params[:user][:name], params[:user][:password]
    if user
       log_user user,"Logado com sucesso!", :office_root
      empty_cart

    else
      flash[:error]="Dados incorretos, tente novamente!"
      redirect_to :new_session
    end
  end

  def destroy
    unlog_user "Usuário deslogado com sucesso!", :sign_in
    empty_cart

  end

end

