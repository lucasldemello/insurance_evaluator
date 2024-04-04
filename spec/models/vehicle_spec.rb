require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:year).only_integer.is_greater_than_or_equal_to(1800).is_less_than_or_equal_to(Date.current.year) }

    it 'validates the creation of a vehicle' do
      vehicle = build(:vehicle)
      expect(vehicle).to be_valid
    end

    it 'its not valid without a user' do
      vehicle = build(:vehicle)
      vehicle.user = nil
      expect(vehicle).not_to be_valid
    end
  end
end
