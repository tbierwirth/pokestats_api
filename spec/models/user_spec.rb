require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:password)}
    it {should validate_confirmation_of(:password)}
    it {should have_secure_password}
  end
end
