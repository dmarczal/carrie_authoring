class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end
end
