#encoding: UTF-8
class Admin::OrdersController < Admin::AdminController

  def index
    @q = Order.search(params[:q])
    @orders = @q.result.includes(:cart,:user).order("id desc").page(params[:page]).per_page(25)
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    if @order.update_attributes(params[:order], without_protection:true)
      flash[:notice] = "Atualizado com sucesso"
      redirect_to admin_order_path(@order)
    else
      render action: :edit
    end
  end

  def close
    @order = Order.find(params[:id])
    @order.make_comm=true
    @order.paid_with_money=true
    @order.mailing=true
  end

  def close_proc
    @order = Order.find(params[:id])

    if @order.update_attributes(params[:order], without_protection:true)
      flash[:notice] = "Pagamento concluído com sucesso"
      redirect_to admin_order_path(@order)
    else
      render action: :close
    end
  end

  def block_comms
    @order = Order.find(params[:id])

    @order.toggle_blocked_comms
    flash[:notice] = "O dispositivo foi acionado. Verifique o resultado!"
    redirect_to admin_order_path(@order)

  end



  def emails
    ids=params[:ids].split
    orders=Order.where(id:ids).includes(:user)
    emails=orders.map do |x|
      [x.user.email1, x.user.email2]
    end
    @emails=emails.flatten.compact.uniq
  end

end
