class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path
  before_filter :authenticate_user!
end
