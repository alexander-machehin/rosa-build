class BuildListsController < ApplicationController
  before_filter :authenticate_user!, :except => [:status_build, :pre_build, :post_build, :circle_build, :new_bbdt]
  before_filter :authenticate_build_service!, :only => [:status_build, :pre_build, :post_build, :circle_build, :new_bbdt]
  before_filter :find_platform, :only => [:index, :filter, :show]
  before_filter :find_repository, :only => [:index, :filter, :show]
  before_filter :find_project, :only => [:index, :filter, :show]
  before_filter :find_arches, :only => [:index, :filter]
  before_filter :find_branches, :only => [:index, :filter]

  before_filter :find_build_list_by_bs, :only => [:status_build, :pre_build, :new_bbdt]

  def index
    @build_lists = @project.build_lists.recent.paginate :page => params[:page]
    @filter = BuildList::Filter.new(@project)
  end

  def filter
    @filter = BuildList::Filter.new(@project, params[:filter])
    @build_lists = @filter.find.paginate :page => params[:page]

    render :action => "index"
  end

  def show
    @build_list = @project.build_lists.find(params[:id])
    @item_groups = @build_list.items.group_by_level
  end

  def status_build
    @item = @build_list.items.find_by_name!(params[:package_name])
    @item.status = params[:status]
    @item.save
    
    @build_list.container_path = params[:container_path]
    @build_list.notified_at = Time.now

    @build_list.save

    render :nothing => true, :status => 200
  end

  def pre_build
    @build_list.status = BuildList::BUILD_STARTED
    @build_list.container_path = params[:container_path]
    @build_list.notified_at = Time.now

    @build_list.save

    render :nothing => true, :status => 200
  end

  def post_build
    @build_list.status = params[:status]
    @build_list.container_path = params[:container_path]
    @build_list.notified_at = Time.now

    @build_list.save

    render :nothing => true, :status => 200
  end

  def circle_build
    @build_list.is_circle = true
    @build_list.container_path = params[:container_path]
    @build_list.notified_at = Time.now

    @build_list.save

    render :nothing => true, :status => 200
  end

  def new_bbdt
    @build_list.name = params[:name]
    @build_list.additional_repos = params[:additional_repos]
    @build_list.set_items(params[:items])
    @build_list.save

    render :nothing => true, :status => 200
  end

  protected
    def find_platform
      @platform = Platform.find params[:platform_id]
    end

    def find_repository
      @repository = @platform.repositories.find(params[:repository_id])
    end

    def find_project
      @project = @repository.projects.find params[:project_id]
    end

    def find_arches
      @arches = Arch.recent
    end

    def find_branches
      @git_repository = @project.git_repository
      @branches = @git_repository.branches
    end

    def find_build_list_by_bs
      @build_list = BuildList.find_by_bs_id!(params[:id])
    end

end