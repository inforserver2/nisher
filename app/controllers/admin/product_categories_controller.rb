#encoding: UTF-8
class Admin::ProductCategoriesController < Admin::AdminController
  # GET /admin/product_categories
  # GET /admin/product_categories.json
  def index
    @admin_product_categories = ProductCategory.paginate(:page=>params[:page], :per_page=>10).order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_product_categories }
    end
  end

  # GET /admin/product_categories/1
  # GET /admin/product_categories/1.json
  def show
    @admin_product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_product_category }
    end
  end

  # GET /admin/product_categories/new
  # GET /admin/product_categories/new.json
  def new
    @admin_product_category = ProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_product_category }
    end
  end

  # GET /admin/product_categories/1/edit
  def edit
    @admin_product_category = ProductCategory.find(params[:id])
  end

  # POST /admin/product_categories
  # POST /admin/product_categories.json
  def create
    @admin_product_category = ProductCategory.new(params[:product_category])

    respond_to do |format|
      if @admin_product_category.save
        format.html { redirect_to [:admin,@admin_product_category], notice: 'Criado com sucesso.' }
        format.json { render json: @admin_product_category, status: :created, location: @admin_product_category }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product_categories/1
  # PUT /admin/product_categories/1.json
  def update
    @admin_product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      if @admin_product_category.update_attributes(params[:product_category])
        format.html { redirect_to [:admin,@admin_product_category], notice: 'Atualizado com sucesso.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_categories/1
  # DELETE /admin/product_categories/1.json
  def destroy
    @admin_product_category = ProductCategory.find(params[:id])
    begin
      @admin_product_category.destroy
      flash[:notice]="#{@admin_product_category.title} foi deletado com sucesso"
      respond_to do |format|
        format.html { redirect_to admin_product_categories_url }
        format.json { head :ok }
      end
    rescue ArgumentError=>e
      flash[:error]=e.message
      redirect_to :back
    end

  end
end
