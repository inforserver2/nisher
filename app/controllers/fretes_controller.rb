#encoding: UTF-8
class FretesController < ApplicationController

  skip_before_filter :subdomain_filter, :set_session_obj
  before_filter :expire_session_control, :require_login , only: :address_copy

    # GET /fretes
  # GET /fretes.json
  def index
    @fretes = Frete.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fretes }
    end
  end

  # GET /fretes/1
  # GET /fretes/1.json
  def show
    @frete = Frete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frete }
    end
  end

  # GET /fretes/new
  # GET /fretes/new.json
  def new
    @frete = Frete.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @frete }
    end
  end

  # GET /fretes/1/edit
  def edit
    @frete = Frete.find(params[:id])
  end

  # POST /fretes
  # POST /fretes.json
  def create
    @frete = Frete.new(params[:frete])

    respond_to do |format|
      if @frete.save
        format.html { redirect_to @frete, notice: 'Frete was successfully created.' }
        format.json { render json: @frete, status: :created, location: @frete }
      else
        format.html { render action: "new" }
        format.json { render json: @frete.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fretes/1
  # PUT /fretes/1.json
  def update
    @frete = Frete.find(params[:id])

    respond_to do |format|
      if @frete.update_attributes(params[:frete])
        format.html { redirect_to @frete, notice: 'Frete was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @frete.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fretes/1
  # DELETE /fretes/1.json
  def destroy
    @frete = Frete.find(params[:id])
    @frete.destroy

    respond_to do |format|
      format.html { redirect_to fretes_url }
      format.json { head :ok }
    end
  end

  def type
    @cart=current_cart
    if params[:type]=="sedex"
      @cart.frete.price=@cart.frete.query.last[:sedex].valor
    elsif params[:type]=="pac"
      @cart.frete.price=@cart.frete.query.last[:pac].valor
    else
      raise "não foi possivel atualizar o valor do frete"
    end
    @cart.frete.save
    respond_to do |format|
      format.json {render json: {price: @cart.final_price.real_contabil}}
    end
  end

  def address_copy
    @user=current_user
    @address=@user.address
    respond_to do |format|
      format.js
    end
  end
end
