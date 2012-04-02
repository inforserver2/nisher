class Admin::FretesController < Admin::AdminController
  def edit
    @frete=Frete.find(params[:id])
  end
  def update
    @frete = Frete.find(params[:id])

    if @frete.update_attributes(params[:frete], without_protection:true)
      flash[:notice] = "Frete atualizado com sucesso"
      redirect_to admin_order_path(@frete.cart.order)
    else
      render action: :edit
    end
  end
end
