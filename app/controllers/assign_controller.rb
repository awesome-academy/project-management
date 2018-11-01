class AssignController < ApplicationController
  def create
    card = Card.find_by id: params[:id]
    user = User.find_by id: params[:user_id]
    if card.nil? || user.nil?
      flash[:danger] = t "assign.cannot_assign"
      redirect_to root_path
    end
    @project = card.task.project
    unless Relationship.exists? user_id: user.id, project_id: @project.id
      flash[:danger] = t "assign.cannot_assign"
      redirect_to card
    end
    begin
      card.assigns.create! user_id: user.id
      card.events.create! user_id: current_user.id,
        event_type: Event.assignee,
        content: t("assign.event") % [user.name, card.name]
    rescue
      flash[:danger] = t "assign.cannot_assign"
    end
    redirect_to card
  end
end
