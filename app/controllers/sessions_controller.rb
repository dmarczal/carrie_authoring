class SessionsController < Devise::SessionsController
  before_filter :load_breadcumb

  private
  def load_breadcumb
    add_breadcrumb "Login", :new_user_session_path
  end
end
