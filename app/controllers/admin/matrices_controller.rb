class Admin::MatricesController < Admin::AdminController
  def index
    @q = Matrix.search(params[:q])
    @matrices = @q.result.includes(:user).order("id desc").page(params[:page]).per_page(25)
  end
  def emails
    ids=params[:ids].split
    matrices=Matrix.where(id:ids).includes(:user)
    emails=matrices.map do |x|
      [x.user.email1, x.user.email2]
    end
    @emails=emails.flatten.compact.uniq
  end
end
