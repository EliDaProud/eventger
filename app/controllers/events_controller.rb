class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  api :GET, '/events'
  param :token, String, desc: "Authorization token", required: true

  def index
    events = Event.all

    if current_user
      render json: events
    else
      render json: {}, status: 401
    end
  end

  api :POST, '/events'
  param :token, String, desc: "Authorization token", required: true
  param :event, Hash, desc: "Wrapper key", required: true do
    param :title, String, desc: "Title of the event", required: true
    param :description, String, desc: "Description of the event", required: true
    param :start_time, String, desc: "When the event starts - date and time", required: true
    param :end_time, String, desc: "When the event ends - date and time", required: true
    param :icon, String, desc: "String code representing the icon", required: true
  end

  def create
    event = Event.new(event_params)

    if current_user
      event.author = current_user
      if event.valid?
        event.save!
        render json: {}, status: 201
      else
        render json: {error: event.errors.messages}, status: 400
      end
    else
      render json: {}, status: 401
    end
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :icon)
  end
end
