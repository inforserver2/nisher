class Admin::JobsController < Admin::AdminController

  def index
    @q = Job.search(params[:q])
    @jobs=@q.result.order("id desc").page(params[:page]).per_page(25)
  end

  def show
    @job=Job.where(id:params[:id]).first
  end

  def run
    id=params[:id].to_i
    res=case id
      when 1 then
        system("/usr/local/bin/rake auto:cart_clean[1]")
      when 2 then
        system("/usr/local/bin/rake payment:generator[1]")
      when 3 then
        system("/usr/local/bin/rake carrier:cache_clean[1]")
      when 4 then
        system("/usr/local/bin/rake users:inactive[1]")
      when 5 then
        system("/usr/local/bin/rake users:suspend[1]")
      when 6 then
        system("/usr/local/bin/rake users:birthday[1]")
      when 7 then
        system("/usr/local/bin/rake orders:reminder[1]")
      when 8 then
        system("/usr/local/bin/rake users:pre_inactive_reminder[1]")
      when 9 then
        system("/usr/local/bin/rake users:pre_suspend_reminder[1]")
      when 10 then
        system("/usr/local/bin/rake users:auto_charge[1]")
      else
        nil
    end
    if res
      flash[:success] = "Tarefa executada com sucesso."
      redirect_to admin_job_path(Job.last)
    else
      flash[:error] = "Ocorreu um erro ao executar a tarefa, tente novamente ou entre em contato com o administrador do sistema."
      redirect_to admin_jobs_path
    end

  end

end
