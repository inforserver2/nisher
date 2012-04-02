class Office::UsersController < PrivateController
  def show
    @user=current_user
  end

  def dados_pessoais_form
    @user=current_user
  end

  def dados_pessoais_proc
    @user=current_user
    if @user.update_attributes(params[:user],as: :office_user)
      flash[:success]="Dados alterados com sucesso!"
      redirect_to :office_meus_dados
    else
      render action: :dados_pessoais_form
    end
  end

  def dados_contato_form
    @user=current_user
  end

  def dados_contato_proc
    @user=current_user
    if @user.update_attributes(params[:user],as: :office_user)
      flash[:success]="Dados alterados com sucesso!"
      redirect_to :office_meus_dados
    else
      render action: :dados_contato_form
    end
  end

  def minha_senha_form
    @user=current_user
  end

  def minha_senha_proc
    @user=current_user
    @user.require_pwd=true
    if @user.update_attributes(params[:user],as: :office_user)
      flash[:success]="Dados alterados com sucesso!"
      redirect_to :office_meus_dados
    else
      render action: :minha_senha_form
    end
  end

  def dados_endereco_form
    @user=current_user
  end

  def dados_endereco_proc
    @user=current_user
    if @user.update_attributes(params[:user],as: :office_user)
      flash[:success]="Dados alterados com sucesso!"
      redirect_to :office_meus_dados
    else
      render action: :dados_endereco_form
    end
  end

  def dados_banco_form
    @user=current_user
    unless @user.bank_account.present?
      @user.build_bank_account
    end
  end

  def dados_banco_proc
    @user=current_user
    if @user.update_attributes(params[:user],as: :office_user)
      flash[:success]="Dados alterados com sucesso!"
      redirect_to :office_meus_dados
    else
      render action: :dados_banco_form
    end
  end




end
