#encoding: UTF-8
class Office::NetworkingController < PrivateController

  before_filter :requirements, only: [:activate, :activate_proc]
  before_filter :rule1, except: [:activate, :activate_proc, :activated, :sponsor]

  def activate
    unless @user.bank_account.present?
      @user.build_bank_account
    end
  end

  def activate_proc
      respond_to do |format|
        if @user.update_attributes(params[:user], as: :office_networker)
          format.js { render :js => "window.location.replace('#{office_networking_activated_path}');" }
        else
          format.html do
           if request.xhr?
              unless @user.bank_account.present?
                @user.build_bank_account
              end
             render :action => "activate", :status => :unprocessable_entity
           end
          end
        end
      end
  end

  def activated
    flash.now[:notice] = "Sua conta foi setada como agente de negócios. Para concluir sua ativação na rede realize a compra de um dos kits de negócios abaixo:"
    @products=Product.where(network_plan:true, visible:true)
  end

  def stats
    @levels=current_user.matrix.network_count_collection
    @clients=current_user.sponsored.where(account_type_id:1).size
    @pending_users=current_user.sponsored.where(account_type_id:2).visible
  end

  def level
    @q=current_user.matrix.network(params[:id]).search(params[:q])
    @matrices = @q.result.includes(:user,:upline=>:user).order("id desc").page(params[:page]).per_page(25)
  end

  def clients
    @q=current_user.sponsored.where(account_type_id:1).search(params[:q])
    @clients = @q.result.order("id desc").page(params[:page]).per_page(25)
  end

  def show
    unless current_user.matrix.id.in? Matrix.sponsors_up params[:id]
      flash[:notice] = "Sem permissão para acessar este tipo de dados"
      redirect_to :office_root
    end
    @matrix=Matrix.where(id:params[:id]).first
  end

  def client
    @client=current_user.sponsored.find_by_id(params[:id])
  end

  def pending
    @q=current_user.sponsored.where(account_type_id:2).visible.search(params[:q])
    @users = @q.result.includes(:sponsor).order("id desc").page(params[:page]).per_page(25)
  end

  def sponsor
    if params[:id]=="1"
      @personal=current_user.sponsor
      @type="indicador"
    elsif params[:id]=="2"
      @personal=current_user.matrix.upline.user
      @type="upline"
    else
      raise "sponsor id not valid"
    end
  end

  private

  def requirements
    @user=current_user
    if @user.account_type_id==2
      flash[:notice] = "Conta negócios"
      redirect_to :office_root
    end
  end
  def rule1
    unless current_user.matrix.present?
      flash[:notice] = "O acesso aos recursos da rede de negócios só será permitido após você realizar a compra de um dos kits de negócios.<a href=\"#{office_networking_activated_path}\"> Clique aqui para conhecer as opções.</a> ".html_safe
      redirect_to :office_root
    end
  end


end
