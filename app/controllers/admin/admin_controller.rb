#encoding: UTF-8
class Admin::AdminController < PrivateController
  before_filter :admin_verification
  private
  def admin_verification
    unless current_user.admin?
      flash[:notice] = "Acesso não permitido para este usuário."
      redirect_to :office_root
    end
  end
end

