# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceManager::AutoInsurance, type: :model do
  let(:user) do
    create(:user, age: 41,
                  income: 150_000, dependents: 0, marital_status: 'single',
                  risk_questions: [0, 0, 0], vehicle: create(:vehicle, year: 2000))
  end
  let(:ineligible_user) do
    create(:user)
  end

  describe '#call' do
    it 'creates an insurance score' do
      auto_insurance = InsuranceManager::AutoInsurance.new(user)
      expect { auto_insurance.call }.to change(InsuranceScore, :count).by(1)
    end
  end

  describe '#insurance_type' do
    it 'returns the correct insurance type' do
      auto_insurance = InsuranceManager::AutoInsurance.new(user)
      expect(auto_insurance.send(:insurance_type)).to eq('auto')
    end
  end

  describe '#ineligible?' do
    context 'when user has no vehicle' do
      it 'returns true' do
        auto_insurance = InsuranceManager::AutoInsurance.new(ineligible_user)
        expect(auto_insurance.send(:ineligible?)).to be true
      end
    end

    context 'when user age is not greater than 60' do
      it 'returns false' do
        auto_insurance = InsuranceManager::AutoInsurance.new(user)
        expect(auto_insurance.send(:ineligible?)).to be false
      end
    end
  end

  describe '#adjust_score' do
    it 'returns the standard risk score' do
      auto_insurance = InsuranceManager::AutoInsurance.new(user)
      auto_insurance.send(:call)
      expect(auto_insurance.send(:score)).to eq(0)
    end

    context 'when the rules apply' do
      it 'returns none if user is ineligible' do
        auto_insurance = InsuranceManager::AutoInsurance.new(ineligible_user)
        auto_insurance.send(:call)
        expect(auto_insurance.send(:score)).to eq(nil)
      end

      it 'returns -2 if user age is lesser than 30' do
        user.update(age: 25)
        auto_insurance = InsuranceManager::AutoInsurance.new(user)
        auto_insurance.send(:call)
        expect(auto_insurance.send(:score)).to eq(-2)
      end

      it 'return -1 if user age is between 30 and 40' do
        user.update(age: 34)
        auto_insurance = InsuranceManager::AutoInsurance.new(user)
        auto_insurance.send(:call)
        expect(auto_insurance.send(:score)).to eq(-1)
      end

      it 'return +1 if user vehicle has five years' do
        user.vehicle.update(year: Date.current.year)
        auto_insurance = InsuranceManager::AutoInsurance.new(user)
        auto_insurance.send(:call)
        expect(auto_insurance.send(:score)).to eq(1)
      end
    end
  end
end
