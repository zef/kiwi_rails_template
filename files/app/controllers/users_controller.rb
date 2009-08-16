class UsersController < ApplicationController

  access_control do
    allow :admin
    allow logged_in, :to => [ :edit, :update ]
    allow anonymous, :to => [ :new, :create ]
  end

  def index
    if params[:disabled]
      @users = User.disabled
    else
      @users = User.active
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    # @user = User.new(filtered_params(params[:user]))
    @user.save do |result|
      if result
        flash[:notice] = "User was successfully created"
        redirect_to edit_user_path(@user)
      else
        render :action => 'new'
      end
    end
  end

  def edit
    get_authorized_user
  end

  def update
    get_authorized_user
    @user.attributes = filtered_params(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = 'User info was successfully updated.'
        if current_user.has_role?("admin")
          redirect_to users_path
        else
          redirect_to root_path
        end
      else
        render :action => "edit"
      end
    end
  end

  protected

  def get_authorized_user
    if current_user.has_role?("admin")
      @user = params[:id] ? User.find(params[:id]) : current_user
    else
      @user = current_user
    end
  end

  def filtered_params(params)
    unless logged_in? and current_user.has_role?('admin')
      params.reject!{|k, v| k == :user_roles }
      params.reject!{|k, v| k == :active }
    end

    return params
  end

end
