class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_event, only: %i(destroy)

  def create
    @card = Card.find_by id: params[:card_id]
    return unless @card
    @event = @card.events.build event_params
    if @event.save
      flash[:success] = t "event.created"
    else
      flash[:danger] = t "event.uncreated"
    end
    redirect_to card_path @card
  end

  def destroy
    if @event.destroy
      flash[:success] = t "event.deleted"
    else
      flash[:danger] = t "event.delete_error"
    end
    redirect_to request.referrer || :root
  end

  private

  def event_params
    params.require(:event).permit :user_id, :event_type, :content
  end

  def correct_event
    @event = current_user.events.find_by id: params[:id]
    return if @event
    flash[:danger] = t "event.not_found"
    redirect_to request.referrer || :root
  end
end
