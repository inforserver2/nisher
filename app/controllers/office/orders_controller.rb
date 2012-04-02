class Office::OrdersController < PrivateController
  def index
    @orders=current_user.orders.not_blocked.includes(:cart=>:line_items).page(params[:page]).per_page(10)
  end

end
