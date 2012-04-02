#encoding: UTF-8
class Admin::BlacklistUsernamesController < Admin::AdminController
  # GET /blacklist_usernames
  # GET /blacklist_usernames.json
  def index
    @q = BlacklistUsername.search(params[:q])
    @blacklist_usernames = @q.result.order("id desc").page(params[:page]).per_page(25)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blacklist_usernames }
    end
  end


  # GET /blacklist_usernames/new
  # GET /blacklist_usernames/new.json
  def new
    @blacklist_username = BlacklistUsername.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blacklist_username }
    end
  end


  # POST /blacklist_usernames
  # POST /blacklist_usernames.json
  def create
    @blacklist_username = BlacklistUsername.new(params[:blacklist_username])

    respond_to do |format|
      if @blacklist_username.save
        format.html { redirect_to admin_blacklist_usernames_path, notice: t(:created, :name=>"Login proibido") }
        format.json { render json: @blacklist_username, status: :created, location: @blacklist_username }
      else
        format.html { render action: "new" }
        format.json { render json: @blacklist_username.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /blacklist_usernames/1
  # DELETE /blacklist_usernames/1.json
  def destroy
    @blacklist_username = BlacklistUsername.find(params[:id])
    if @blacklist_username.destroy
      flash[:success]= "O login '#{@blacklist_username.name}' foi deletado da lista."
    end


    respond_to do |format|
      format.html { redirect_to admin_blacklist_usernames_url }
      format.json { head :ok }
    end
  end
end
