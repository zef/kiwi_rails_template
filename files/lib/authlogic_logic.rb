module AuthlogicLogic
  protected

  def logged_in?
    !!current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page."
      redirect_to sign_in_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page."
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def access_denied
    flash[:error] = "Sorry, you don't have access to that page."
    redirect_to sign_in_path
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :current_user_session, :logged_in?
  end

end