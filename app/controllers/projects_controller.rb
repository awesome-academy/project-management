class ProjectsController < ApplicationController
  layout "user"
  before_action :authenticate_user!
  before_action :get_project, only: %i(show_member add_member show)

  def index
    @project = current_user.projects.order_created_at
      .page(params[:page]).per Settings.constant.project_per_page
  end

  def show
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

  def show_member
    @member = @project.users
  end

  def add_member
    flash.clear
    user = User.find_by email: params[:email].downcase
    if user.nil?
      flash[:danger] = t "member.email_not_found"
    elsif get_relationship(user.id).present?
      flash[:danger] = t "member.user_in_project"
    else
      relationship = Relationship.new project_id: @project.id,
        user_id: user.id
      flash[:danger] = t "member.add_error" unless relationship.save
    end
    @member = @project.users
    render :show_member
  end

  def remove_member
    relationship = get_relationship params[:user_id]
    if relationship.delete
      redirect_to show_member_project_path
    else
      flash[:danger] = t "member.remove_error"
      render :show_member
    end
  end

  private

  def project_create_params
    params.require(:project).permit :name, :describe
  end

  def get_project
    @project = Project.find_by id: params[:id]
    return unless @project.nil?
    flash[:danger] = t "project.project_not_found"
    redirect_to projects_path
  end

  def get_relationship user_id
    Relationship.find_by project_id: params[:id], user_id: user_id
  end
end
