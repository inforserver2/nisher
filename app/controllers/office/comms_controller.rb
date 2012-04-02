#encoding: UTF-8
class Office::CommsController < PrivateController
  def index
    @q = current_user.comms.not_blocked.search(params[:q])
    @comms=@q.result.order("id desc").page(params[:page]).per_page(25)
  end

  def show
    @comm=current_user.comms.not_blocked.where(id:params[:id]).first
  end

  def transfer
  end

  def transfer_proc
    msg=[]
    to=params[:to_username]
    value=params[:to_value].to_f
    pwd=params[:my_password]
    user=User.where{(name==to) | (email1==to)}.first
    credit=current_user.my_pending_credit
    unless user
      msg << "usuário não encontrado"
    end
    if value < 10 || value > 500
      msg << "valor deve ser entre R$10,00 e R$500"
    end
    if credit < value
      msg << "o valor de crédito solicitado é maior do que o saldo atual"
    end
    if pwd!=current_user.password
      msg << "senha incorreta"
    end
    if msg.any?
      flash.now[:notice] = msg.to_sentence
      render action: :transfer
    else
      ActiveRecord::Base.transaction do
        current_user.comms.create(value:(value-(value*2)), type_id:2, to_user_id:user.id)
        user.comms.create(value:value, type_id:3, from_user_id:current_user.id)
      end
      flash[:success] = "Foi emitido o valor de #{value.real_contabil} para o usuário #{user.get_login}"
      redirect_to :transfer_office_comms
    end
  end

end
