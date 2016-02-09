class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    event = Event.new(event_params)
    if event.valid?
      event.save!
      render json: 201
    else
      render json: 400
    end
  end

private
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :icon)
  end
end
