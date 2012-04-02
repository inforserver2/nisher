class CartsController < ApplicationController
  # GET /carts
  # GET /carts.json
  #
  #
  skip_before_filter :subdomain_filter, :set_session_obj, only:[:reset,:frete_info, :address_completed, :address_input]
  def index
    @carts = Cart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carts }
    end
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    #@cart = Cart.find(params[:id])
    @cart = current_cart

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cart }
    end
  end

  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end


  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.json
  def update
    @cart = current_cart
    @cart.frete.calculate_frete=true
    @cart.assign_attributes params[:cart], :as=>:buyer
    respond_to do |format|
      if @cart.save
        format.html do
          if request.xhr?
           render :json => { :success => true, :message => "Success"}
          else
            redirect_to :carrinho, notice: 'Cart was successfully updated.'
          end
        end
      else
       format.html do 
        if request.xhr?
          render :partial => "address_input", :status => :unprocessable_entity
        else
          render :action => :show, :status => :unprocessable_entity
        end        
       end  
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = current_cart
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to cart_path(0), notice: 'Seu carrinho de compras foi deletado com sucesso.' }
      format.json { head :ok }
    end
  end
  
  def reset
    @cart = current_cart
    @cart.line_items.clear
    @cart.reset_query_frete
    @cart.save
    respond_to do |format|
      format.js
    end
  end

  def frete_info
    @cart = current_cart
    render layout:false
  end

  def address_completed
    @cart = current_cart
    render layout:false
  end
  
  def address_input
    @cart = current_cart
    render file:"carts/_address_input", layout:false
  end

  def set_frete
    @cart = current_cart
    if params[:frete_tipo]=="pac"
      @cart.frete.price = @cart.frete.query.last[:pac].valor
        @cart.frete.frete_type_id = 1
    elsif params[:frete_tipo]=="sedex"
      @cart.frete.price = @cart.frete.query.last[:sedex].valor
        @cart.frete.frete_type_id = 2
    end
    @cart.frete.save
    render layout:false
  end

end
