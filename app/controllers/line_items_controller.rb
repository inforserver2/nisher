#encoding: UTF-8
class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    if is_logged? && current_user.account_type_id==1 && (User.cannot_be_any_in_cont? [params[:product_id].to_i])
      flash[:notice] = "Este kit só poderá ser adquirido pela primeira vez via central de negócios, <a href=\"#{office_networking_activate_path}\">Clique aqui</a> ".html_safe
      redirect_to :back
    else
      @cart = current_cart
      product = Product.find(params[:product_id])
      @line_item = @cart.add_product(product, params[:product_taste_id])

      respond_to do |format|
        if @line_item.save
          format.html { redirect_to :carrinho, notice: 'Você adicionou novo item ao carrinho.' }
        else
          flash[:error]=@line_item.errors[:weight_loss].to_sentence if @line_item.errors[:weight_loss].present?
          format.html { redirect_to :carrinho }
        end
    end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @cart=current_cart
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.js
    end
  end

  def inc
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    @line_item.inc

    respond_to do |format|
      format.js
    end
  end

  def dec
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    @line_item.dec

    respond_to do |format|
      format.js
    end
  end


end
