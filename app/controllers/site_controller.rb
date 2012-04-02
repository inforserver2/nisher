#encoding: UTF-8
class SiteController < ApplicationController

  def index
    render :layout=>"home"
  end

  def about
    render :layout=>"content_wide"
  end

  def office_side
    render :layout=>"content_office_sidebar"

  end

  def office_wide
    render :layout=>"content_office_wide"

  end

  def contrato
    render :layout=>"content_wide"

  end

  def forms
  end

  def nisher
  end

  def renda
    @prospecto=Prospecto.new
    render :layout=>"content_wide"
  end

  def prospecto
    @prospecto=Prospecto.new(params[:prospecto])
    if @prospecto.valid?
        obj=@prospecto.to_json
        ContactMailer.delay.prospecto obj
      flash[:notice] = "Dados enviados com sucesso"
      redirect_to site_renda_path
    else
      render :renda, layout: "content_wide"
    end
  end

  def depoimentos
  end

  def duvidas
  end

  def antispam
  end

  def dicas
  end

  def tv
  end

  def promocoes
  end

  def name
  end

  def cadastro
    unlog_user("Usuário deslogado com sucesso!", :site_cadastro) if is_logged?
  end

end
