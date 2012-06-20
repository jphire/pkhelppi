# encoding: utf-8
class MaterialsController < ApplicationController
  before_filter :signed_in_user
  before_filter :firm_admin, only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_user, only: []

  def show
    @material = Material.find(params[:id])
  end
  
  def new
    @material = Material.new
  end
  
  def create
    @material = Material.new(params[:material])
    @material.firm = @firm
    
    if @material.save
      flash[:success] = "Uusi raaka-aine luotu!"
      redirect_to @firm
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @material.update_attributes(params[:material])
      flash[:success] = "Raaka-aine tallennettu"
      redirect_to @material
    else
      render 'edit'
    end
  end
  
  def destroy
    @material.destroy
    flash[:success] = "Raaka-aine poistettu."
    redirect_to materials_path
  end
  
  private
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Kirjaudu sisään kiitos."
      end
    end
    
    def firm_admin
      if params[:id]
        @material = Material.find(params[:id])
      elsif params[:firm_id]
        @firm = Firm.find(params[:firm_id])
      end
      
      if @material and @material.firm
        admins = @material.firm.users #later change to include only admins
      elsif @firm
        admins = @firm.users #later change to include only admins
      else 
        admins = []
        flash[:error] = "Ei lupaa tehdä muutoksia."
      end
      redirect_to(root_path) unless admins.include? current_user
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end  
end
