require 'rails_helper'

RSpec.describe InsuranceScore, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:insurance_type) }
    it { should validate_presence_of(:score_description) }
  end
end
