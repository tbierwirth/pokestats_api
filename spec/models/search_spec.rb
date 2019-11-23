require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'Relationships' do
    it { should have_one :pokemon }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
