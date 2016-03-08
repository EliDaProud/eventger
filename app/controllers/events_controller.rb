class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  api!
  description "Endpoint for getting all events, regardless if current user joined or not"
  param :token, String, desc: "Authorization token", required: true
  error code: 400, desc: "Token is missing"
  error code: 401, desc: "Wrong authorization token"
  example "{
    id: 2,
    icon: 'icon',
    title: 'rrrr',
    description: 'some text',
    start_time: '2016-03-09T12:25:04.907Z',
    end_time: '2016-03-11T12:25:14.195Z',
    user_id: 3,
    created_at: '2016-02-09T16:07:37.470Z',
    updated_at: '2016-03-08T12:25:31.149Z'
    }"

  def index
    events = Event.all

    if current_user
      render json: events
    else
      render json: {}, status: 401
    end
  end

  api!
  param :token, String, desc: "Authorization token", required: true
  param :event, Hash, desc: "Wrapper key", required: true do
    param :title, String, desc: "Title of the event", required: true
    param :description, String, desc: "Description of the event", required: true
    param :start_time, String, desc: "When the event starts - date and time", required: true
    param :end_time, String, desc: "When the event ends - date and time", required: true
    param :icon, String, desc: "String code representing the icon", required: true
  end
  error code: 401, desc: "Wrong authorization token"
  error code: 400, desc: "Event is not valid"
  error code: 400, desc: "Token is missing"

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

  api!
  param :token, String, desc: "Authorization token", required: true
  param :id, Integer, desc: "ID for the event", required: true
  error code: 400, desc: "Token is missing"
  error code: 401, desc: "Wrong authorization token"
  error code: 403, desc: "User is not the author of the event"

  def destroy
    event = Event.find(params[:id])

    if current_user
      if event.author == current_user
        event.destroy
        render json: {}, status: 200
      else
        render json: {error: "You are not author of this event!"}, status: 403
      end
    else
      render json: {}, status: 401
    end
  end

  api!
  param :token, String, desc: "Authorization token", required: true
  param :id, Integer, desc: "ID for the event", required: true
  error code: 400, desc: "Token is missing"
  error code: 401, desc: "Wrong authorization token"

  def join
    event = Event.find(params[:id])

    if current_user
      event.users << current_user
      render json: {}, status: 200
    else
      render json: {}, status: 401
    end
  end

  api!
  param :token, String, desc: "Authorization token", required: true
  param :id, Integer, desc: "ID for the event", required: true
  error code: 400, desc: "Token is missing"
  error code: 401, desc: "Wrong authorization token"

  def leave
    event = Event.find(params[:id])

    if current_user
      current_user.events.delete(event)
      render json: {}, status: 200
    else
      render json: {}, status: 401
    end
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :icon)
  end
end
