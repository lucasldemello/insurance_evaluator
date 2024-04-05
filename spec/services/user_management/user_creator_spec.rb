# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManagement::UserCreator, type: :service do
  let(:user_params) { { age: 35, dependents: 2, income: 0, marital_status: 'married', risk_questions: [0, 1, 0] } }
  let(:vehicle_params) { { year: 2018 } }
  let(:house_params) { { ownership_status: 'owned' } }

  describe '#call' do
    context 'when valid params are provided' do
      it 'creates a new user with associated vehicle and house' do
        service = described_class.new(user_params, vehicle_params, house_params)

        expect { service.call }.to change(User, :count).by(1)
        expect(User.last.age).to eq(35)
        expect(User.last.dependents).to eq(2)
        expect(Vehicle.last.year).to eq(2018)
        expect(Vehicle.last.user).to eq(User.last)
        expect(House.last.user).to eq(User.last)
        expect(House.last.ownership_status).to eq('owned')
      end

      it 'returns true when user is successfully created' do
        service = described_class.new(user_params, vehicle_params, house_params)

        expect(service.call).to eq(true)
      end
    end

    context 'when invalid params are provided' do
      it 'does not create a new user' do
        invalid_user_params = { age: nil, dependents: 2, income: 0, marital_status: 'married',
                                risk_questions: [0, 1, 0] }
        service = described_class.new(invalid_user_params, vehicle_params, house_params)

        expect { service.call }.to_not change(User, :count)
      end

      it 'returns false when user creation fails' do
        invalid_user_params = { age: nil, dependents: 2, income: 0, marital_status: 'married',
                                risk_questions: [0, 1, 0] }
        service = described_class.new(invalid_user_params, vehicle_params, house_params)

        expect(service.call).to eq(false)
      end
    end
  end
end
