class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    @categories = ProductCategory.includes(:products).order("id ASC").reject{|x| x.id == 1}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.visibles.where(id:params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def more
    @product = Product.find(params[:id])

    render :layout=>false


  end

end
