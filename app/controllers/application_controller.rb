#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Você não possui acesso à essa página!"
    redirect_to root_url
  end
end
