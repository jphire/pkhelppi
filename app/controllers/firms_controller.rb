# encoding: utf-8
class FirmsController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_tax
  before_filter :admin_user,     only: [:new, :create, :destroy]

  def show
    @firm = Firm.find(params[:id])
    if current_user.admin?  
      if @firm.resource.class == Bakery
        @bakery = Bakery.find(params[:id])
      end
    else
      if @firm.resource.class == Bakery
        @bakery = Bakery.find(params[:id])
        @recipes = @bakery.recipes
        @materials = @bakery.materials
      end
    end
  end
  
  def index
    if current_user.admin?
      @firms = Firm.paginate(:page => params[:page], :per_page => 10)
    else
      sql = " SELECT *
      FROM firms AS f
      WHERE f.id IN (SELECT u.firm_id 
        FROM firms_users AS u 
        WHERE user_id='#{current_user.id}')"
      @firms = Firm.paginate_by_sql(sql, :page => params[:page], :per_page => 10)
    end
  end
  
  def new
    @firm = Firm.new
    @bakery = Bakery.new
  end
  
  def create
    @firm = Firm.new(params[:firm])
    @firm.attributes = params[:firm]
    @firm.resource = Bakery.new(params[:resource])
    
    if params[:users]
      params[:users].each do |user_id|
        user = User.find(user_id)
        @firm.users.push user
      end
    end
    
    if @firm.save
      flash[:success] = "Yritys onnistuneesti luotu"
      redirect_to firms_path
    else
      flash.now[:error] = "Yrityksen luonti ei onnistunut."
      render 'new'
    end
  end
  
  def edit
    @firm = Firm.find(params[:id])
    @bakery = Bakery.find(params[:id])
  end
  
  def update
    @firm = Firm.find(params[:id])
    bakery = Bakery.find(params[:id])
    @firm.attributes = params[:firm]
    @firm.resource = bakery
    
    if params[:users]
      params[:users].each do |user_id|
        user = User.find(user_id)
        @firm.users.push user
      end
    end
    
    if @firm.save
      flash[:success] = "Yrityksen tiedot päivitetty"
      redirect_to @firm
    else
      render 'edit'
    end
  end
  
  def destroy
    Firm.find(params[:id]).destroy
    flash[:success] = "Yritys poistettu."
    redirect_to firms_path
  end
  
  private
    
    def set_tax
      @tax = 0.13
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Kirjaudu sisään."
      end
    end
    
    def admin_user
      if current_user
        redirect_to(root_path) unless current_user.admin?
      else
        redirect_to(root_path)
      end
    end
end
