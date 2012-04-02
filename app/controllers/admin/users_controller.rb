#encoding: UTF-8
class Admin::UsersController < Admin::AdminController

  def index
    @q = User.search(params[:q])
    if params[:total].present? && params[:total].to_i >= 0
      params[:start_date]=(Time.now-1.year).to_date.to_s_br if params[:start_date].blank?
      params[:end_date]=(Time.now+1.year).to_date.to_s_br if params[:end_date].blank?
      @users = User.qualified_members @q.result, params[:total].to_i, params[:start_date], params[:end_date]
      @users = @users.includes(:sponsor).order("users.id desc").page(params[:page]).per_page(25)
    else
      @users = @q.result.includes(:sponsor).order("users.id desc").page(params[:page]).per_page(25)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.account_type_id==2
      @user.build_bank_account unless @user.bank_account.present?
    end

    if @user.update_attributes(params[:user], without_protection:true)
      flash[:notice] = "Atualizado com sucesso"
      redirect_to admin_user_path(@user)
    else
      render action: :edit
    end
  end

#  def destroy
#    @user = User.find(params[:id])
#    if @user.destroy
#      flash[:notice] = "Usuário deletado com sucesso."
#      redirect_to admin_users_path
#    else
#      flash[:notice]="Não foi possível remover este usuário."
#      redirect_to admin_users_path(page:params[:page])
#    end
#  end

  def emails
    ids=params[:ids].split
    users=User.find(ids)
    emails=users.map do |x|
      [x.email1, x.email2]
    end
    @emails=emails.flatten.compact.uniq
  end

  def mass_signup_form
    unless CFG["adminfakeusers"]==true
      flash[:notice] = "Acesso não autorizado, entre em ontato com o administrador do sistema."
      redirect_to office_root_path
    end
    @users=[]
  end

  def mass_signup_post
    unless CFG["adminfakeusers"]==true
      flash[:notice] = "Acesso não autorizado, entre em ontato com o administrador do sistema."
      redirect_to office_root_path
    end

    alerts=[]
    qty=params[:qty].to_i
    level=params[:level].to_i
    nickname=params[:nickname]
    redir_from=params[:sorting]=="1" ? "none": nil
    sponsor=params[:sponsor].to_i
    mailing=params[:mailing].present?
    closing=params[:closing].present?
    product_id=params[:product_id].to_i
    make_comm=params[:make_comm].present?
    account_type_id=params[:type_id].to_i
    mx_btn=false
    gen_cart_seed=true
    mass=true
    @users=[]


    unless qty.in? 1..1000
      alerts << "qtd deve ser entre 1 e 1000"
    end
#    unless level.in? 0..8
#      alerts << "nível deve ser entre 0 e 8"
    unless level.in? 0..4
      alerts << "nível deve ser entre 0 e 4"
    end
    unless account_type_id.in? 1..2
      alerts << "tipo de conta deve ser consumo ou negócios"
    end
    sponsor_user=User.where(id:sponsor).includes(:matrix).first
    if level == 0
      matrices=[sponsor_user.matrix]
    else
      matrices=sponsor_user.matrix.network level
    end
    unless names_valid(nickname, qty, matrices)==false
      alerts << "apelido em uso"
    end
    unless sponsor_user.present?
      alerts << "id indicador inexistente"
      unless sponsor_user.account_type_id == 2
        alerts << "um novo cadastro depende de um indicador do tipo negócios"
      end
    end
    if alerts.any?
      flash.now[:notice] = alerts.to_sentence
      render :mass_signup_form
    else
      if matrices.any?
        matrices.each do |matrix|
          qty.times do |n|
            name="#{nickname}#{n}x#{matrix.user_id}"
            @users << User.find_or_create_by_name({person_type_id:1, person_nick:"apelido #{name}", person_name:"nome #{name}", account_type_id:account_type_id,cpf:"00985241519",name:"#{name}",email1:"#{name}@mylinuxserver1.info", email2:"", admin:false, password:"vtr512", sponsor_id:matrix.user_id,address_attributes:{street_name:"Trv. 2 de maio", number:"29", complement:"Ao lado da Semed",neighborhood:"Centro", city_name:"Camaçari", state_name:"BA", country_id: 29, zip:"42800-530"},matrix_button:mx_btn, closing:closing,gen_cart_seed:gen_cart_seed, mailing:mailing, make_comm:make_comm,fake:true,redir_from:redir_from, comes_from_id:7, mass:mass, product_id:product_id},without_protection:true);
          end
        end
      end


      flash.now[:notice] = "Cadastros realizados"
      render :mass_signup_form

    end

  end

  def users_matrices
  end

  private

  def names_valid nickname, qty, matrices
    nicks=[]
    qty.times do |n|
      matrices.each do |matrix|
        name="#{nickname}#{n}x#{matrix.user_id}"
        nicks << name
      end
    end
    users=User.find_all_by_name nicks
    count=users.size > 0
  end

end
