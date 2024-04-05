# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManagement::UserCreator, type: :service do
  let(:user_params) { { age: 35, dependents: 2, income: 0, marital_status: 'married', risk_questions: [0, 1, 0] } }
  let(:vehicle_params) { { year: 2018 } }
  let(:house_params) { { ownership_status: 'owned' } }

  describe '#call' do
    context 'when valid params are provided' do
      let(:service) { described_class.new(user_params, vehicle_params, house_params) }

      it 'creates a new user with associated vehicle and house' do
        expect { service.call }.to change { User.count }.by(1)
      end

      it 'associates the vehicle with the new user' do
        service.call
        expect(Vehicle.last.year).to eq(2018)
        expect(Vehicle.last.user).to eq(User.last)
      end

      it 'associates the house with the new user' do
        service.call
        expect(House.last.user).to eq(User.last)
        expect(House.last.ownership_status).to eq('owned')
      end

      it 'returns a valid user if is successfully created' do
        user = service.call
        expect(user.valid?).to eq(true)
      end
    end

    context 'when only user params are provided' do
      let(:service) { described_class.new(user_params, {}, {}) }

      it 'creates a new user even if vehicle and house params are not provided' do
        expect do
          service.call
        end.to change(User, :count).by(1)
                                   .and change(Vehicle, :count).by(0)
                                                               .and change(House, :count).by(0)
      end
    end

    context 'when invalid params are provided' do
      let(:invalid_user_params) do
        { age: nil, dependents: 2, income: 0, marital_status: 'married', risk_questions: [0, 1, 0] }
      end
      let(:invalid_service) { described_class.new(invalid_user_params, vehicle_params, house_params) }

      it 'does not create a new user' do
        expect { invalid_service.call }.not_to(change { User.count })
      end

      it 'returns false when user creation fails' do
        user = invalid_service.call
        expect(user.valid?).to eq(false)
      end
    end
  end
end
