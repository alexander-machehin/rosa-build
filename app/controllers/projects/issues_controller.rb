# -*- encoding : utf-8 -*-
class Projects::IssuesController < Projects::BaseController
  NON_RESTFUL_ACTION = [:create_label, :update_label, :destroy_label]
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only => [:index, :show] if APP_CONFIG['anonymous_access']
  load_resource :project
  load_and_authorize_resource :issue, :through => :project, :find_by => :serial_id, :only => [:show, :edit, :update, :destroy, :new, :create, :index]
  before_filter :load_and_authorize_label, :only => NON_RESTFUL_ACTION

  layout false, :only => [:update, :search_collaborators]

  def index(status = 200)
    @is_assigned_to_me = params[:filter] == 'to_me'
    @status = params[:status] == 'closed' ? 'closed' : 'open'
    @labels = params[:labels] || []
    @issues = @project.issues
    @issues = @issues.where(:assignee_id => current_user.id) if @is_assigned_to_me
    @issues = @issues.joins(:labels).where(:labels => {:name => @labels}) unless @labels == []
    # Using mb_chars for correct transform to lowercase ('Русский Текст'.downcase => "Русский Текст")
    @issues = @issues.where('issues.title ILIKE ?', "%#{params[:search_issue].mb_chars.downcase}%") if params[:search_issue]

    @opened_issues, @closed_issues = @issues.opened.count, @issues.closed.count
    @issues = @issues.where(:status => @status)
                      .includes(:assignee, :user).order('serial_id desc').uniq.paginate :per_page => 10, :page => params[:page]
    if status == 200
      render 'index', :layout => request.xhr? ? 'issues' : 'application'
    else
      render :status => status, :nothing => true
    end
  end

  def new
  end

  def create
    @assignee_uname = params[:assignee_uname]
    @issue.user_id = current_user.id

    if @issue.save
      @issue.subscribe_creator(current_user.id)
      flash[:notice] = I18n.t("flash.issue.saved")
      redirect_to project_issues_path(@project)
    else
      flash[:error] = I18n.t("flash.issue.save_error")
      render :action => :new
    end
  end

  def update
    @issue.labelings.destroy_all if params[:update_labels]
    if params[:issue] && status = params[:issue][:status]
      @issue.set_close(current_user) if status == 'closed'
      @issue.set_open if status == 'open'
      render :partial => 'status', :status => (@issue.save ? 200 : 500)
    elsif params[:issue]
      status = @issue.update_attributes(params[:issue]) ? 200 : 500
      render :inline => view_context.markdown(@issue.body), :status => status
    else
      render :nothing => true, :status => 200
    end
  end

  def destroy
    @issue.destroy
    flash[:notice] = t("flash.issue.destroyed")
    redirect_to root_path
  end

  def create_label
    index(@project.labels.create!(:name => params[:name], :color => params[:color]) ? 200 : 500)
  end

  def update_label
    index(@label.update_attributes(:name => params[:name], :color => params[:color]) ? 200 : 500)
  end

  def destroy_label
    index((@label && @label_destroy) ? 200 : 500)
  end

  def search_collaborators
    search = "%#{params[:search_user]}%"
    users = User.joins(:groups => :projects).where(:projects => {:id => @project.id}).where("users.uname ILIKE ?", search)
    users2 = @project.collaborators.where("users.uname ILIKE ?", search)
    @users = (users + users2).uniq.sort {|x,y| x.uname <=> y.uname}.first(10)
    render :partial => 'search_collaborators'
  end

  private

  def load_and_authorize_label
    @label = Label.find(params[:label_id]) if params[:label_id]
    authorize! :write, @project
  end
end
