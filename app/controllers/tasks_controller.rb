class TasksController < ApplicationController
  layout "user_working"
  before_action :authenticate_user!
  before_action :get_project
  before_action :logged_in?, only: %i(create destroy new)

  def new
    @task = @project.tasks.build
  end

  def create
    @task = @project.tasks.build task_params
    if @task.save
      flash[:success] = t "task.created"
      redirect_to project_path(@project)
    else
      flash[:danger] = t "task.uncreated"
      redirect_to new_project_task_path(@project)
    end
  end

  def destroy
    correct_project
    if @task.destroy
      flash[:success] = t "task.deleted"
    else
      flash[:danger] = t "task.delete_error"
    end
    redirect_back fallback_location: project_path(@project)
  end

  private

  def task_params
    params.require(:task).permit :name
  end

  def correct_project
    @project = current_user.projects.find_by id: params[:project_id]
    @task = @project.tasks.find_by id: params[:id]
    return if @task && @project
    flash[:danger] = t "task.not_found"
    redirect_to :root
  end

  def get_project
    @project = Project.find_by id: params[:project_id]
    return unless @project.nil?
    flash[:danger] = t "project.project_not_found"
    redirect_to projects_path
  end
end

