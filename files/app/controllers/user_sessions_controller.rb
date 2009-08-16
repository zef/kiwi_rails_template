class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create], :unless => :current_user_can_create_users
  before_filter :require_user, :only => [:destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    @user_session.save do |result|
      if result
        flash[:notice] = "Sign in successful!"
        redirect_back_or_default root_path
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Sign out successful!"
    redirect_back_or_default sign_out_path
  end

  protected

  def current_user_can_create_users
    logged_in? and current_user.has_role?('admin')
  end
end
