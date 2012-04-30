#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path
  I18n.locale = 'pt-br'

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Você não possui acesso à essa página!"
    redirect_to root_url
  end

  protected
  def ckeditor_authenticate
    if @asset
      authorize! action_name, @asset
    end
  end

  def ckeditor_filebrowser_scope(options = {})
    super({ :assetable_id => current_user.id, :assetable_type => 'User' }.merge(options))
  end
end
