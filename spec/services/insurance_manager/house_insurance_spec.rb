# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceManager::HouseInsurance, type: :model do
  let(:user) do
    create(:user, age: 41, risk_questions: [0, 0, 0], house: create(:house, ownership_status: 'owned'))
  end
  let(:ineligible_user) do
    create(:user)
  end

  describe '#call' do
    it 'creates an insurance score' do
      house_insurance = InsuranceManager::HouseInsurance.new(user)
      expect { house_insurance.call }.to change(InsuranceScore, :count).by(1)
    end
  end

  describe '#insurance_type' do
    it 'returns the correct insurance type' do
      house_insurance = InsuranceManager::HouseInsurance.new(user)
      expect(house_insurance.send(:insurance_type)).to eq('house')
    end
  end

  describe '#ineligible?' do
    context 'when user has no vehicle' do
      it 'returns true' do
        house_insurance = InsuranceManager::HouseInsurance.new(ineligible_user)
        expect(house_insurance.send(:ineligible?)).to be true
      end
    end

    context 'when user age is not greater than 60' do
      it 'returns false' do
        house_insurance = InsuranceManager::HouseInsurance.new(user)
        expect(house_insurance.send(:ineligible?)).to be false
      end
    end
  end

  describe '#call' do
    it 'returns the standard risk score' do
      house_insurance = InsuranceManager::HouseInsurance.new(user)
      house_insurance.send(:call)
      expect(house_insurance.send(:score)).to eq(0)
    end

    context 'when the rules apply' do
      it 'returns none if user is ineligible' do
        house_insurance = InsuranceManager::HouseInsurance.new(ineligible_user)
        house_insurance.send(:call)
        expect(house_insurance.send(:score)).to eq(nil)
      end

      it 'returns -2 if user age is lesser than 30' do
        user.update(age: 25)
        house_insurance = InsuranceManager::HouseInsurance.new(user)
        house_insurance.send(:call)
        expect(house_insurance.send(:score)).to eq(-2)
      end

      it 'return -1 if user age is between 30 and 40' do
        user.update(age: 34)
        house_insurance = InsuranceManager::HouseInsurance.new(user)
        house_insurance.send(:call)
        expect(house_insurance.send(:score)).to eq(-1)
      end

      it 'return +1 if user house is rented' do
        user.house.update(ownership_status: 'rented')
        house_insurance = InsuranceManager::HouseInsurance.new(user)
        house_insurance.send(:call)
        expect(house_insurance.send(:score)).to eq(1)
      end
    end
  end
end
