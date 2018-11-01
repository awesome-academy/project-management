class CardsController < ApplicationController
  layout "user_working"
  before_action :authenticate_user!
  before_action :load_card, only: %i(show update)
  before_action :check_member, only: %i(show update)
  before_action :load_project_and_card, only: %i(new create)
  before_action :correct_card, only: %i(edit destroy)
  before_action :load_for_update, only: %i(edit update)

  def show
    @events = @card.events.order_by_created_at_desc
    @event = @card.events.build user_id: current_user.id
    @project = @card.task.project
  end

  def create
    @card = @task.cards.build card_params
    if @card.save
      flash[:success] = t "card.created"
      @card.events.create! user_id: current_user.id,
        event_type: "card_create", content: t("event.card_create")
      @card.assigns.create! user_id: current_user.id
      redirect_to project_path @project
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

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @card = Card.find_by id: params[:id]
      @task = Task.find_by id: params[:task_id]
      if @task.nil? || @card.nil?
        flash[:danger] = t "card.cannot_move_card"
        redirect_to @card
      end
      @card.task_id = params[:task_id]
      @card.save!
      event = @card.events.build user_id: current_user.id,
        event_type: Event.card_update,
        content: t("card.move_to") + @task.name
      event.save!
      redirect_to @card
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "card.cannot_move_card"
      redirect_to @card
  end

  private

  def card_params
    params.require(:card).permit :user_id, :task_id, :name, :activated, :describe
  end

  def load_project_and_card
    @project = Project.find_by id: params[:project_id]
    @task = Task.find_by id: params[:task_id]
    return if @task && @project
    flash[:danger] = t "task.not_found"
    redirect_to :root
  end

  def load_card
    @card = Card.find_by id: params[:id]
    return if @card
    flash[:danger] = t "task.not_found"
    redirect_to project_path @project
  end

  def correct_card
    @card = current_user.cards.find_by id: params[:id]
    return if @card
    flash[:danger] = t "task.not_found"
    redirect_to projects_path
  end

  def load_for_update
    @task = @card.task
    @project = @task.project
  end

  def check_member
    project = @card.task.project
    return unless project
    members = project.users
    return unless members
    return if members.exists? current_user.id
    flash[:danger] = t "card.not_permission"
    redirect_to projects_path
  end
end
