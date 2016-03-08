require 'rest_client'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :authenticate

  def authenticate
    if params[:token]
      # Authorization already exists, the user is in our database with a valid token
      if authorization = Authorization.find_by(token: params["token"])
        @current_user = authorization.user
      else
        # Authorization doesnt exist yet - either a new user or existing one with expired token
        user_info = get_user_info
        if user_info
          isid = user_info["isid"]
          @current_user = User.find_or_create_by(isid: isid)
          @current_user.authorization = Authorization.new(token: params[:token])
        end
        # If user_info did not return anything, current_user is null and it will be checked in other controllers
      end
    else
      render json: {error: "Token parameter is missing!"}, status: 400
    end
  end

  def current_user
    @current_user
  end

  private

  # if the token is valid, it returns user data
  def get_user_info
    response = RestClient.get 'https://iapi.merck.com/oauth2/v1/userinfo',
      { 'Authorization' => 'Bearer ' + params["token"] }
    if response.code == 200
      JSON.parse(response)
    end
  rescue RestClient::Unauthorized => e
    puts 'You are so unauthorized :O'
  end
end
