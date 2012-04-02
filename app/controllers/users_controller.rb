#encoding: UTF-8
class UsersController < ApplicationController
  skip_before_filter :subdomain_filter, :set_session_obj, :expire_session_control, :only=>[:ident, :check_for_email, :check_for_name]


  # GET /users
  # GET /users.json
#  def index
#    @users = User.paginate(:page=>params[:page])
#    @session = User.new
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @users }
#    end
#  end
#
  # GET /users/1
  # GET /users/1.json
#  def show
#    @user = User.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @user }
#    end
#  end

  def check_cart_frete_validation
    mailing=true
    @cart = current_cart
    @product_ids=@cart.line_items.pluck(:product_id)
    if is_logged? && current_cart.valid_to_order?
        order=current_user.orders.create(price:@cart.final_price, cart_id:@cart.id, mailing:mailing, creating:true)
        clear_cart if order
        redirect_to order_path(order, token:order.token,new_order:"true")
    elsif !is_logged? && current_cart.valid_to_order?
      @user = User.new
      @user.person_type_id ||= 1
      @user.build_bank_account
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to carrinho_path
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    check_cart_frete_validation
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    mailing=true
    @cart = current_cart
    if is_logged? && current_cart.valid_to_order?
        order=current_user.orders.create(price:@cart.final_price, cart_id:@cart.id, mailing:mailing, creating:true)
        clear_cart if order
        format.js { render :js => "window.location.replace('#{order_path(order, token:order.token,:new_order=>"true")}');" }
    elsif !is_logged? && current_cart.valid_to_order?
      @user = User.new(params[:user], as: :signup)
        @user.build_address(street_name:@cart.frete.street_name,
                            number: @cart.frete.number,
                            neighborhood: @cart.frete.neighborhood,
                            complement: @cart.frete.complement,
                            city_name: @cart.frete.city_name,
                            state_name: @cart.frete.state_name,
                            country_id: @cart.frete.country_id,
                            zip: @cart.frete.zip_to)
      @user.sponsor_id=@sponsor.id
      @user.redir_from=session[:sponsor][:redir_from] if session[:sponsor][:redir_from].present?
      @user.cart_id=@cart.id
      @user.mailing=mailing
      @user.products=@cart.line_items.pluck(:product_id)

      respond_to do |format|
        if @user.save
          log_user @user
          clear_cart if @user.orders.first
          format.js { render :js => "window.location.replace('#{order_path(@user.orders.first, token:@user.orders.first.token,:new_order=>"true", :new_user=>"true" )}');" }
        else
          format.html do
           if request.xhr?
             render :partial => "form", :status => :unprocessable_entity
           end
          end
        end
      end
    else
      redirect_to carrinho_path
    end
  end

  # PUT /users/1
  # PUT /users/1.json
#  def update
#    @user = User.find(params[:id])
#
#    respond_to do |format|
#      if @user.update_attributes(params[:user])
#        format.html { redirect_to @user, notice: 'User was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#      end
#    end
#  end


  def switch_to_user

    user = User.find_by_id_and_token(params[:id],params[:token])
    if user && current_master.admin?
      session[:logged][:user][:id]= user.id
      session[:logged][:user][:token]= user.token
      flash[:success]="Sublogado com sucesso"
      redirect_to :office_root
    else
      flash[:error]="Não foi possivel sublogar, entre em contato com o administrador do sistema."
      redirect_to :back
    end

  end

  def return_to_user

    if session[:logged][:user][:id]!=session[:logged][:master][:id]
      session[:logged][:user]=session[:logged][:master].dup
      flash[:success]="Usuário retornado com sucesso!"
      redirect_to :back
    else
      flash[:error]="Não foi possível retornar o usuário, entre em contato com o administrador do sistema"
      redirect_to :back
    end

  end

  def send_my_password
    if params[:email].present?
      user = User.password_recover params[:email]
      if user
        UserMailer.delay.send_my_password user
        flash[:success]="A senha está sendo enviado para seu email."
        redirect_to :back
      else

        flash[:error]="Email não encontrado."
        redirect_to :back
      end
    end
  end

  def ident
   redirect_to root_url(:subdomain=>params[:name])
  end


  def check_for_name
    user = User.new({:name=>params[:name]}, without_protection:true)
    user.ignore_sponsor=true
    user.valid?
    if user.errors[:name].any?
      render :text=>"<span class=\"validation_error\">Erro: O login '#{user.name}' #{user.errors[:name].to_sentence}.Verifique e tente novamente!</span>"
    else
      render :text=>"<span class=\"validation_success\">Login '#{user.name}' disponível</span>"
    end
  end

  def check_for_email
    user = User.new({:email1=>params[:email]}, without_protection:true)
    user.ignore_sponsor=true
    user.valid?
    if user.errors[:email1].any?
      render :text=>"<span class=\"validation_error\">Erro: O email '#{user.email1}' #{user.errors[:email1].to_sentence}.Verifique e tente novamente!</span>"
    else
      render :text=>"<span class=\"validation_success\">Email '#{user.email1}' disponível</span>"
    end
  end

end
