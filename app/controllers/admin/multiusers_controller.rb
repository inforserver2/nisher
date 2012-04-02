#encoding: UTF-8
class Admin::MultiusersController < Admin::AdminController
  # GET /multiusers
  # GET /multiusers.json
  def index
    @q = Multiuser.search(params[:q])
    @multiusers = @q.result.order("id desc").page(params[:page]).per_page(25)

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  # GET /multiusers/new
  # GET /multiusers/new.json
  def new
    @multiuser = Multiuser.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  # POST /multiusers
  # POST /multiusers.json
  def create
    @multiuser = Multiuser.new(params[:multiuser])

    respond_to do |format|
      if @multiuser.save
        format.html { redirect_to admin_multiusers_path, notice: t(:created, :name=>"Multiusuário permitido") }
      else
        format.html { render action: "new" }
      end
    end
  end


  # DELETE /multiusers/1
  # DELETE /multiusers/1.json
  def destroy
    @multiuser = Multiuser.find(params[:id])
    if @multiuser.destroy
      flash[:success]= "O multiusuário '#{@multiuser.cpfcnpj}' foi deletado da lista."
    end

    respond_to do |format|
      format.html { redirect_to admin_multiusers_url }
      format.json { head :ok }
    end
  end
end
