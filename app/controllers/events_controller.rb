class EventsController < ApplicationController
  respond_to :json

  def create
    event = Event.new(event_params)
    if event.valid
      event.save!
      return 201
    else
      return 400
  end

private
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :icon)
  end
end
