#encoding: UTF-8

class Admin::BoletosController < Admin::AdminController
  # GET /admin/pages
  # GET /admin/pages.json
  def index
    @q = Boleto.search(params[:q])
    @boletos = @q.result.order("boletos.id desc").page(params[:page]).per_page(25)

  end

  # GET /admin/pages/1
  # GET /admin/pages/1.json
  def show
    @boleto = Boleto.find(params[:id])

  end

  # GET /admin/pages/new
  # GET /admin/pages/new.json
  def new

    @boleto = Boleto.new

  end

  # GET /admin/pages/1/edit
  def edit
    @boleto = Boleto.find(params[:id])
  end

  # POST /admin/pages
  # POST /admin/pages.json
  def create
    @boleto = Boleto.new(params[:boleto])

    respond_to do |format|
      if @boleto.valid?
        expire=Chronic.parse @boleto.start_date
        num=@boleto.qtd.to_i
        num.times do |b|
          boleto=Boleto.new @boleto.attributes
          boleto.qtd=@boleto.qtd
          boleto.start_date=@boleto.start_date
          boleto.expire_date=expire
          boleto.save
          expire+=30.days
          format.html { redirect_to admin_boletos_path, notice: t(:created, :name=>"Boleto") }
        end
        #format.html { redirect_to [:admin, @boleto], notice: t(:created, :name=>"Boleto") }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /admin/pages/1
  # PUT /admin/pages/1.json
  def update
    @boleto = Boleto.find(params[:id])

    respond_to do |format|
      if @boleto.update_attributes(params[:boleto])
        format.html { redirect_to [:admin, @boleto], notice: t(:updated, :name=>"Boleto") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.json
  def destroy
    @boleto = Boleto.find(params[:id])
    begin
      @boleto.destroy
      if @boleto.destroy
        flash[:success]=t(:deleted, :name=>"Boleto")
      end

      respond_to do |format|
        format.html { redirect_to admin_boletos_url }
      end
    rescue ArgumentError=>e
      flash[:error]=e.message
      redirect_to :back
    end
  end
end
