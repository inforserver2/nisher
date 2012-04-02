#encoding: UTF-8
class Admin::ProductsController < Admin::AdminController
 load_and_authorize_resource
  # GET /admin/products
  # GET /admin/products.json
  def index
    @q = Product.search params[:q]
    @admin_products = @q.result.paginate(:page=>params[:page], :per_page=>12).order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_products }
    end
  end

  # GET /admin/products/1
  # GET /admin/products/1.json
  def show
    @admin_product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_product }
    end
  end

  # GET /admin/products/new
  # GET /admin/products/new.json
  def new
    @admin_product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_product }
    end
  end

  # GET /admin/products/1/edit
  def edit
    @admin_product = Product.find(params[:id])
  end

  # POST /admin/products
  # POST /admin/products.json
  def create
    @admin_product = Product.new(params[:product])

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to [:admin,@admin_product], notice: t(:created, :name=>"Produto") }
        format.json { render json: @admin_product, status: :created, location: @admin_product }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/products/1
  # PUT /admin/products/1.json
  def update
    @admin_product = Product.find(params[:id])
    params[:product][:product_category_ids]||=[]

    respond_to do |format|
      if @admin_product.update_attributes(params[:product])
        format.html { redirect_to [:admin,@admin_product], notice: t(:updated, :name=>"Produto") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1
  # DELETE /admin/products/1.json
  def destroy
    @admin_product = Product.find(params[:id])
    if @admin_product.destroy
      flash[:success]=t(:deleted, :name=>"Produto")
    end


    respond_to do |format|
      format.html { redirect_to admin_products_url }
      format.json { head :ok }
    end
  end
end
