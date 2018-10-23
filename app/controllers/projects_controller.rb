class ProjectsController < ApplicationController
  layout "user"
  before_action :validate_login

  def index
    @projects = Project.get_by_user(current_user)
      .page(params[:page]).per Settings.constant.project_per_page
  end

  def show
    @project = Project.find_by id: params[:id]
    if @project
      @task = Task.new
      @tasks = @project.tasks.order_by_created_at_desc
    else
      flash[:danger] = t "project.not_found"
      redirect_to projects_path
    end
  end

  def new
    @project = Project.new
  end

  def create
    ActiveRecord::Base.transaction do
      @project = Project.new project_create_params
      @project.save!
      relationship = @project.relationships
        .build user: current_user, is_manager: true
      relationship.save!
      redirect_to projects_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def validate_login
    return if logged_in?
    flash[:danger] = t "login.required"
    redirect_to login_url
  end

  def project_create_params
    params.require(:project).permit :name, :describe
  end
end
