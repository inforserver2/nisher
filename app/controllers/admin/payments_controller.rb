#encoding: UTF-8
class Admin::PaymentsController < Admin::AdminController

  def index
    @q = Payment.search(params[:q])
    @payments = @q.result.order("id desc").page(params[:page]).per_page(25)

  end

  def show
    @payment = Payment.find(params[:id])
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])

    if @payment.update_attributes(params[:payment], without_protection:true)
      flash[:notice] = "Atualizado com sucesso"
      redirect_to admin_payment_path(@payment)
    else
      render action: :edit
    end
  end

  def update_p_bank_account_info
    @payment = Payment.find(params[:id])
    @payment.update_p_bank_account_info
    flash[:notice] = "O dispositivo foi ativado com sucesso. Verifique o resultado."
    redirect_to admin_payment_path(@payment)
  end

  def close
    @payment = Payment.find(params[:id])
    @payment.closed=true
    if @payment.save
      flash[:success] = "O envio de pagamento foi baixado com sucesso, verifique o resultado."
    else
      flash[:notice] = "Houve um erro entre em contato com o programador."
    end
    redirect_to admin_payment_path(@payment)
  end

end
