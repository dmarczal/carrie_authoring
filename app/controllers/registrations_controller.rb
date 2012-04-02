class RegistrationsController < Devise::RegistrationsController
  before_filter :change_mass_assignment, :only => [:update]
  before_filter :change_mass_assignment_create, :only => [:create]
  before_filter :add_breadcrumb_edit, :only => :edit
  before_filter :add_breadcrumb_new, :only => [:new, :create]

  private
  def change_mass_assignment
    unless current_user.admin? && current_user.id != params[:user][:id]
      params[:user].delete(:type)
      params[:user].delete(:email)
    end
  end

  def change_mass_assignment_create
    unless current_user.present? && current_user.admin?
      params[:user].delete(:type) if params[:user][:type].eql?('admin')
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
