#encoding: UTF-8

class Admin::PagesController < Admin::AdminController
  skip_before_filter :expire_session_control,:subdomain_filter, :set_session_obj, :require_login, :admin_verification, :only=>[:content]
#  load_and_authorize_resource
#  skip_authorize_resource :only => :content
  # GET /admin/pages
  # GET /admin/pages.json
  def index
    @admin_pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_pages }
    end
  end

  # GET /admin/pages/1
  # GET /admin/pages/1.json
  def show
    @admin_page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_page }
    end
  end

  # GET /admin/pages/new
  # GET /admin/pages/new.json
  def new
    @admin_page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_page }
    end
  end

  # GET /admin/pages/1/edit
  def edit
    @admin_page = Page.find(params[:id])
  end

  # POST /admin/pages
  # POST /admin/pages.json
  def create
    @admin_page = Page.new(params[:page])

    respond_to do |format|
      if @admin_page.save
        format.html { redirect_to [:admin, @admin_page], notice: t(:created, :name=>"Pagina") }
        format.json { render json: @admin_page, status: :created, location: @admin_page }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/pages/1
  # PUT /admin/pages/1.json
  def update
    @admin_page = Page.find(params[:id])

    respond_to do |format|
      if @admin_page.update_attributes(params[:page])
        format.html { redirect_to [:admin, @admin_page], notice: t(:updated, :name=>"Pagina") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.json
  def destroy
    @admin_page = Page.find(params[:id])
    begin
      @admin_page.destroy
      if @admin_page.destroy
        flash[:success]=t(:deleted, :name=>"Pagina")
      end

      respond_to do |format|
        format.html { redirect_to admin_pages_url }
        format.json { head :ok }
      end
    rescue ArgumentError=>e
      flash[:error]=e.message
      redirect_to :back
    end
  end

  def content
    @admin_page = Page.find(params[:id])
    render :layout=>false
  end
end
