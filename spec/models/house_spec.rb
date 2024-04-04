require 'rails_helper'

RSpec.describe House, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:ownership_status) }
  end

  describe 'enums' do
    it { should define_enum_for(:ownership_status).with_values(owned: 'owned', rented: 'rented').backed_by_column_of_type(:string) }
  end
end
