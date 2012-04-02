#encoding: UTF-8
class Admin::NewsController < Admin::AdminController

  def index
    @q = News.search(params[:q])
    @news = @q.result.order("id desc").page(params[:page]).per_page(5)
  end

  def destroy
    @news = News.find(params[:id])
    if @news.destroy
      flash[:success] = "Email deletado com sucesso."
      redirect_to :admin_news_index
    else
      flash[:notice]="Não foi possível remover este email."
      redirect_to :back
    end
  end

  def emails
    ids=params[:ids].split
    emails=News.where(id:ids, blocked:false)
    emails=emails.map do |x|
      [x.email]
    end
    @emails=emails.flatten.compact.uniq
  end

  def block
    @news=News.find(params[:id])
    @news.blocked=true
    if @news.save
      flash[:success] = "Bloqueado com sucesso"
    else
      flash[:error] = "Houve algum erro, entre em contato com o administrador."
    end
    redirect_to :back
  end

  def unblock
    @news=News.find(params[:id])
    @news.blocked=false
    if @news.save
      flash[:success] = "Desbloqueado com sucesso"
    else
      flash[:error] = "Houve algum erro, entre em contato com o administrador."
    end
    redirect_to :back
  end

end
