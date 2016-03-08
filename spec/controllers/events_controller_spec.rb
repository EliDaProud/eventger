require "rails_helper"

RSpec.describe EventsController do
  describe "GET index" do

    before(:each) do
      Event.create(title: "Cool event!", description: "It will be amazing!", start_time: 1.day.from_now, end_time: 4.days.from_now, icon: "some icon")
      Event.create(title: "Cool event! 2", description: "It will be mediocre...", start_time: 3.days.from_now, end_time: 5.days.from_now, icon: "some icon")
      Event.create(title: "Cool event! 3", description: "It will be boring :/", start_time: 5.days.from_now, end_time: 7.days.from_now, icon: "some icon")
    end

    it "doesnt return any data if user is not signed up" do
      stub_request(:get, "https://iapi.merck.com/oauth2/v1/userinfo").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer non-existing', 'User-Agent'=>'Ruby'}).
         to_return(:status => 401, :body => "{'error':'invalid_authentication','error_description':'Reason: invalid_access_token'}", :headers => {})

      get :index, token: "non-existing"

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)).to eq({})
    end

    it "return data if user is recognized and exists" do
      user = User.create(isid: "dostalov")
      authorization = Authorization.create(token: "some valid token")
      user.authorization = authorization

      get :index, token: "some valid token"
      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body)[0]["title"]).to eq("Cool event!")
    end

    it "return data and create new user" do
      response_body = {
          'isid': 'dostalov',
          'given_name': 'Zuzana',
          'family_name': 'Dostalova',
          'email': 'zuzana.dostalova@merck.com',
          'sub': 'dostalov'
        }

       stub_request(:get, "https://iapi.merck.com/oauth2/v1/userinfo").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer some valid token', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => response_body.to_json, :headers => {})

      get :index, token: "some valid token"

      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body)[0]["title"]).to eq("Cool event!")

      expect(User.first.isid).to eq('dostalov')
      expect(User.first.authorization.token).to eq('some valid token')
    end
  end

  describe 'POST create' do 
    it 'creates a new event with current user and valid data' do
      user = User.create(isid: 'dostalov')
      authorization = Authorization.create(token: 'some valid token')
      user.authorization = authorization

      event_params = { title: 'event', description: 'text', icon: 'icon', start_time: 3.days.from_now, end_time: 5.days.from_now }
      post :create,  { token: 'some valid token', event: event_params }

      expect(response.code).to eq('201')
      expect(Event.count).to eq(1)
      expect(Event.last.title).to eq('event')
      expect(Event.last.author).to eq(user)
    end

    it 'fails when user is unauthorized' do
        stub_request(:get, "https://iapi.merck.com/oauth2/v1/userinfo").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer some non-existing', 'User-Agent'=>'Ruby'}).
         to_return(:status => 401, :body => "{'error':'invalid_authentication','error_description':'Reason: invalid_access_token'}", :headers => {})

      event_params = { title: 'event', description: 'text', icon: 'icon', start_time: 3.days.from_now, end_time: 5.days.from_now }
      post :create,  { token: 'some non-existing', event: event_params }

      expect(response.code).to eq('401')
    end

    it 'fails when data is missing' do
      user = User.create(isid: 'dostalov')
      authorization = Authorization.create(token: 'some valid token')
      user.authorization = authorization

      event_params = { description: 'text', icon: 'icon', start_time: 3.days.from_now, end_time: 5.days.from_now }
      post :create,  { token: 'some valid token', event: event_params }

      expect(response.code).to eq('400')
      expect(response.body).to eq("{\"error\":{\"title\":[\"can't be blank\"]}}")
    end
  end

  describe 'DESTROY delete' do
    it 'deletes my event' do
      user = User.create(isid: 'dostalov')
      authorization = Authorization.create(token: 'some valid token')
      user.authorization = authorization

      event = Event.create(title: "Cool event!", description: "It will be amazing!", start_time: 1.day.from_now, end_time: 4.days.from_now, icon: "some icon")
      event.author = user
      event.save!

      delete :destroy, { token: 'some valid token', id: event.id }
      expect(response.code).to eq("200")
      expect(Event.all.size).to eq(0)
    end

    it ' does not delete foreign event' do
      user = User.create(isid: 'dostalov')
      authorization = Authorization.create(token: 'some valid token')
      user.authorization = authorization

      event = Event.create(title: "Cool event!", description: "It will be amazing!", start_time: 1.day.from_now, end_time: 4.days.from_now, icon: "some icon")

      delete :destroy, { token: 'some valid token', id: event.id }
      expect(response.code).to eq("403")
      expect(Event.all.size).to eq(1)
    end
  end
end
