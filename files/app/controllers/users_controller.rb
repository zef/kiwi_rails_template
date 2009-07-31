class UsersController < ApplicationController

  access_control do
    allow :admin
    allow all, :to => [ :edit, :update ]
    deny anonymous, :except => [ :new, :create ]
    allow anonymous, :to => [ :new, :create ]
  end

  def index
    @active_users = User.active
    @disabled_users = User.disabled
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(filtered_params(params[:user]))
    if @user.save
      flash[:notice] = "User was successfully created"
      redirect_to edit_user_path(@user)
    else
      render :action => 'new'
    end
  end

  def edit
    get_authorized_user
  end

  def update
    get_authorized_user

    if @user.update_attributes(filtered_params(params[:user]))
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

  protected

  def get_authorized_user
    if current_user.has_role?("admin")
      @user = User.find(params[:id]) || current_user
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
