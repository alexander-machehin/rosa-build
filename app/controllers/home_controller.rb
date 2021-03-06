class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:activity, :issues, :pull_requests]

  def root
    render 'pages/tour/abf-tour-project-description-1', layout: 'tour'
  end

  def activity
    @filter = t('feed_menu').has_key?(params[:filter].try(:to_sym)) ? params[:filter].to_sym : :all
    @activity_feeds = current_user.activity_feeds
    @activity_feeds = @activity_feeds.where(kind: "ActivityFeed::#{@filter.upcase}".constantize) unless @filter == :all
    @activity_feeds = @activity_feeds.paginate page: params[:page]
    respond_to do |format|
      format.html { request.xhr? ? render('_list', layout: false) : render('activity') }
      format.atom
    end
  end

  def issues
    @created_issues  = current_user.issues
    @assigned_issues = Issue.where(assignee_id: current_user.id)
    pr_ids = Project.accessible_by(current_ability, :membered).uniq.pluck(:id)
    @all_issues = Issue.where(project_id: pr_ids)
    @created_issues, @assigned_issues, @all_issues =
      if action_name == 'issues'
        [@created_issues.without_pull_requests,
         @assigned_issues.without_pull_requests,
         @all_issues.without_pull_requests]
      else
        [@created_issues.joins(:pull_request),
         @assigned_issues.joins(:pull_request),
         @all_issues.joins(:pull_request)]
      end

    case params[:filter]
    when 'created'
      @issues = @created_issues
    when 'assigned'
      @issues = @assigned_issues
    else
      params[:filter] = 'all' # default
      @issues = @all_issues
    end
    @filter = params[:filter]
    @opened_issues, @closed_issues = @issues.not_closed_or_merged.count, @issues.closed_or_merged.count

    @status = params[:status] == 'closed' ? :closed : :open
    @issues = @issues.send( (@status == :closed) ? :closed_or_merged : :not_closed_or_merged )

    @sort       = params[:sort] == 'updated' ? :updated : :created
    @direction  = params[:direction] == 'asc' ? :asc : :desc
    @issues = @issues.order("issues.#{@sort}_at #{@direction}")
                     .includes(:assignee, :user, :pull_request).uniq
                     .paginate per_page: 20, page: params[:page]
    render 'issues', layout: request.xhr? ? 'with_sidebar' : 'application'
  end

  def pull_requests
    issues
  end
end