#encoding: UTF-8
class ViaController < ApplicationController

  before_filter :require_login, only:[:saldo]
  skip_before_filter :subdomain_filter, :set_session_obj, :expire_session_control, only: [:order, :manual]

  def boleto
    redirect_to "/vendor/boletophp/boleto_bradesco.php?id=#{params[:id]}&token=#{params[:token]}"
  end

  def boleto_manual
    redirect_to "/vendor/boletophp/boleto_bradesco_manual.php?id=#{params[:id]}&token=#{params[:token]}"
  end

  def pagseguro
    redirect_to "/vendor/pagseguro/conn.php?id=#{params[:id]}&token=#{params[:token]}"
  end

  def paypal
    redirect_to "/vendor/paypal/conn.php?id=#{params[:id]}&token=#{params[:token]}"
  end

  def saldo
    @order = Order.where(id:params[:id]).first
    if @order.update_attributes({closing:true, mailing:true, pay_via_credit:true},without_protection:true)
      flash[:notice] = "Pagamento concluído com sucesso"
      redirect_to order_path(@order, token:@order.token)
    else
      errors=@order.errors.full_messages.to_sentence
      flash[:notice] = errors
      redirect_to order_path(@order, token:@order.token)
    end
  end


  def order
    @order = Order.where(id:params[:id]).first
    @pack = {order_id:@order.id,
              order_price:@order.price.to_f,
              order_token: @order.token,
              order_desc: @order.description,
              user_name: @order.user.get_name,
              user_id: @order.user.get_id,
              user_email1: @order.user.email1,
              user_person_type_id: @order.user.person_type_id}

    respond_to do |format|
      format.json { render :json => @pack }
    end
  end

  def manual
    @boleto = Boleto.where(id:params[:id]).first
    @pack = {order_id:@boleto.id,
              order_price:@boleto.price.to_f,
              order_token: @boleto.token,
              user_name: @boleto.name,
              user_email1: @boleto.email,
              expire_date: @boleto.expire_date.to_s_br
    }

    respond_to do |format|
      format.json { render :json => @pack }
    end
  end

end
