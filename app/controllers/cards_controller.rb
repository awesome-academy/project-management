class CardsController < ApplicationController
  layout "user_working"
  before_action :authenticate_user!
  before_action :load_project_and_card, only: %i(new create)
  before_action :correct_card, only: %i(edit update destroy)
  before_action :load_for_update, only: %i(edit update)

  def create
    @card = @task.cards.build card_params
    if @card.save
      flash[:success] = t "card.created"
      redirect_to project_path(@project)
    else
      flash[:danger] = t "card.uncreated"
      render :new
    end
  end

  def destroy
    if @card.destroy
      flash[:success] = t "card.deleted"
    else
      flash[:danger] = t "card.delete_error"
    end
    redirect_to request.referrer || :root
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def update
    if @card.update card_params
      flash[:success] = t "card.updated"
      redirect_to project_path @project
    else
      render :edit
    end
  end

  private

  def card_params
    params.require(:card).permit :user_id, :task_id, :name, :describe
  end

  def load_project_and_card
    @project = Project.find_by id: params[:project_id]
    @task = Task.find_by id: params[:task_id]
    return if @task && @project
    flash[:danger] = t "task.not_found"
    redirect_to :root
  end

  def correct_card
    @card = current_user.cards.find_by id: params[:id]
    return if @card
    flash[:danger] = t "task.not_found"
    redirect_to :root
  end

  def load_for_update
    @task = @card.task
    @project = @task.project
  end
end
