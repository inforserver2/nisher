#encoding: UTF-8
class OrderController < PrivateController

  skip_before_filter :expire_session_control,:require_login, only: [:show]

  def new
    clear_cart
  end

  def show
    @order=Order.where(id:params[:id],token:params[:token],blocked:false).first
    unless @order
      flash[:notice] = "Pedido não encontrado"
      redirect_to :root
    end
    unless is_logged?
      render :layout=>"content_sidebar"
    end
  end

end
