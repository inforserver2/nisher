class Admin::CommsController < Admin::AdminController

  def index
    @q = Comm.search(params[:q])
    @comms = @q.result.order("id desc").page(params[:page]).per_page(25)
  end

  def show
    @comm = Comm.find(params[:id])
  end

  def edit
    @comm = Comm.find(params[:id])
  end

  def update
    @comm = Comm.find(params[:id])

    if @comm.update_attributes(params[:comm], without_protection:true)
      flash[:notice] = "Atualizado com sucesso"
      redirect_to admin_comm_path(@comm)
    else
      render action: :edit
    end
  end
end
