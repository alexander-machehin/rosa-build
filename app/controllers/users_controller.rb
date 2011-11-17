# coding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]
  #before_filter :check_global_access

  authorize_resource

  def index
    @users = User.paginate(:page => params[:user_page])
  end

  def show
    @groups       = @user.groups.uniq
    @platforms    = @user.platforms.paginate(:page => params[:platform_page], :per_page => 10)
    @repositories = @user.repositories.paginate(:page => params[:repository_page], :per_page => 10)
    @projects     = @user.projects.paginate(:page => params[:project_page], :per_page => 10)
  end

  def new
    @user = User.new
    @global_roles = Role.by_acter(User).by_target(:system) + Role.by_acter(:all).by_target(:system)
    @global_roles.map! {|role| [role.name, role.id]}
  end

  def edit
    @global_roles = Role.by_acter(User).by_target(:system) + Role.by_acter(:all).by_target(:system)
    @global_roles.map! {|role| [role.name, role.id]}
  end

  def create
    @user = User.new params[:user]
    @user.global_role_id = params[:user]['global_role_id']
    if @user.save
      flash[:notice] = t('flash.user.saved')
      redirect_to users_path
    else
      flash[:error] = t('flash.user.save_error')
      render :action => :new
    end
  end

  def update
    @user.global_role_id = params[:user]['global_role_id']
    if @user.update_attributes(params[:user])
      flash[:notice] = t('flash.user.saved')
      redirect_to users_path
    else
      flash[:error] = t('flash.user.save_error')
      render :action => :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = t("flash.user.destroyed")
    redirect_to users_path
  end

  protected

    def find_user
      @user = User.find(params[:id])
    end
end
