class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = Project.find_by id: params[:project_id]
    return unless @project
    @task = @project.tasks.build task_params
    if @task.save
      flash[:success] = t "task.created"
    else
      flash[:danger] = t "task.uncreated"
    end
    redirect_to project_path @project
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
    @project = Project.find_by id: params[:project_id]
    return nil unless @project
    @task = @project.tasks.find_by id: params[:id]
    return if @task
    flash[:danger] = t "task.not_found"
    redirect_to :root
  end
end

