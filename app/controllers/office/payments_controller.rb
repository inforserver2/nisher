class Office::PaymentsController < PrivateController

  def index
    @q = current_user.payments.not_blocked.search(params[:q])
    @payments = @q.result.order("id desc").page(params[:page]).per_page(25)
  end

  def show
    @payment = current_user.payments.not_blocked.find(params[:id])
  end
end
