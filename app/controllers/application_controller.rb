class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate

  def authenticate
    # require "uri"
    # require "net/http"
    #
    # Net::HTTP.post_form(URI.parse('http://www.interlacken.com/webdbdev/ch05/formpost.asp'), {})

    require "net/http"
    require "uri"

    uri = URI.parse("https://iapi.merck.com/oauth2/v1/userinfo")
    http = Net::HTTP.new(uri.host, uri.port)
    api_request = Net::HTTP::Get.new(uri.request_uri)
    api_request.initialize_http_header({Authorization: "Bearer x"})
    binding.pry
    res = http.request(api_request)
    puts res.body
  end
end
