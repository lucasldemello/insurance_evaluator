# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceManager::DisabilityInsurance, type: :model do
  let(:user) do
    create(:user, age: 41, income: 150_000, dependents: 0, marital_status: 'single', risk_questions: [0, 0, 0])
  end

  describe '#call' do
    it 'creates an insurance score' do
      disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
      expect { disability_insurance.call }.to change(InsuranceScore, :count).by(1)
    end
  end

  describe '#insurance_type' do
    it 'returns the correct insurance type' do
      disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
      expect(disability_insurance.send(:insurance_type)).to eq('disability')
    end
  end

  describe '#ineligible?' do
    context 'when user age is greater than 60' do
      it 'returns true' do
        user.update(age: 65)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        expect(disability_insurance.send(:ineligible?)).to be true
      end
    end

    context 'when user age is not greater than 60' do
      it 'returns false' do
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        expect(disability_insurance.send(:ineligible?)).to be false
      end
    end


    context 'when user income is zero' do
      it 'returns true' do
        user.update(age: 50, income: 0)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        expect(disability_insurance.send(:ineligible?)).to be true
      end
    end

    context 'when user income is greather than zero' do
      it 'returns false' do
        user.update(age: 50, income: 100_000)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        expect(disability_insurance.send(:ineligible?)).to be false
      end
    end
  end

  describe '#calculate_score' do
    it 'returns the standard risk score' do
      disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
      disability_insurance.send(:calculate_score)
      expect(disability_insurance.send(:score)).to eq(0)
    end

    context 'when the rules apply' do
      it 'returns none if user is ineligible' do
        user.update(age: 65)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        disability_insurance.send(:calculate_score)
        expect(disability_insurance.send(:score)).to eq(nil)
      end

      it 'returns -2 if user age is lesser than 30' do
        user.update(age: 25)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        disability_insurance.send(:calculate_score)
        expect(disability_insurance.send(:score)).to eq(-2)
      end

      it 'return -1 if user age is between 30 and 40' do
        user.update(age: 34)
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        disability_insurance.send(:calculate_score)
        expect(disability_insurance.send(:score)).to eq(-1)
      end

      it 'return +2 if user has dependents and a owned house' do
        user.update(age: 50, dependents: 1, house: create(:house, ownership_status: 'rented'))
        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        disability_insurance.send(:calculate_score)
        expect(disability_insurance.send(:score)).to eq(2)
      end

      it 'returns -1 if user is married' do
        user.update(marital_status: :married)

        disability_insurance = InsuranceManager::DisabilityInsurance.new(user)
        disability_insurance.send(:calculate_score)
        expect(disability_insurance.send(:score)).to eq(-1)
      end
    end
  end
end
