require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe 'Relationships' do
    it { should belong_to :search }
  end
  
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:weight) }
    it { should validate_presence_of(:height) }
    it { should validate_presence_of(:attack) }
    it { should validate_presence_of(:defense) }
    it { should validate_presence_of(:hp) }
  end
end
