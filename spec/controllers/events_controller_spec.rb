require "rails_helper"

RSpec.describe EventsController do
  describe "GET index" do

    before(:each) do
      Event.create(title: "Cool event!", description: "It will be amazing!", start_time: 1.day.from_now, end_time: 4.days.from_now, icon: "some icon")
      Event.create(title: "Cool event! 2", description: "It will be mediocre...", start_time: 3.days.from_now, end_time: 5.days.from_now, icon: "some icon")
      Event.create(title: "Cool event! 3", description: "It will be boring :/", start_time: 5.days.from_now, end_time: 7.days.from_now, icon: "some icon")
    end

    # TODO wrap in VCR to not to do a real request!!!
    it "doesnt return any data if user is not signed up" do
      get :index, token: "non-existing"

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)).to eq({})
    end

    it "return data if user is recognized" do
      user = User.create(isid: "dostalov")
      authorization = Authorization.create(token: "some valid token")
      user.authorization = authorization

      get :index, token: "some valid token"
      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body)[0]["title"]).to eq("Cool event!")
    end
  end
end
