class RegistrationsController < Devise::RegistrationsController
  before_filter :change_mass_assignment, :only => [:update]
  before_filter :add_breadcrumb_edit, :only => :edit
  before_filter :add_breadcrumb_new, :only => [:new, :create]

  private
  def change_mass_assignment
    unless current_user.admin? && current_user.id != params[:user][:id]
      params[:user].delete(:type)
      params[:user].delete(:email)
    end
  end

  private
  def add_breadcrumb_edit
    add_breadcrumb "Editar perfil", :edit_user_registration_path
  end
  def add_breadcrumb_new
    add_breadcrumb "Novo registro", :new_user_registration_path
  end
end
