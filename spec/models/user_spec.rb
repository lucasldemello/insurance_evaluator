require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_one(:vehicle).required(false) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:dependents).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:income).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_presence_of(:marital_status) }
    it { should validate_presence_of(:risk_questions) }

    it 'validates risk_questions array' do
      user = build(:user)
      expect(user).to be_valid

      user.risk_questions = [nil, 'false', 12]
      expect(user).not_to be_valid
    end
  end

  describe 'enums' do
    it { should define_enum_for(:marital_status).with_values(single: 'single', married: 'married').backed_by_column_of_type(:string) }
  end
end
