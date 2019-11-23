require 'rails_helper'

describe 'Users API' do
  describe 'POST /users' do
    it 'creates a user when valid credentials are given' do
      user = {
        "email": "tyler@gmail.com",
        "password": "password",
        "password_confirmation": "password"
      }
      post '/api/v1/users', params: user

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(response.body).to include(User.last.api_key)
    end
  end
end
