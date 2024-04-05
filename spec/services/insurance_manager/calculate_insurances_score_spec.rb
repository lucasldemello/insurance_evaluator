# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceManager::CalculateInsurancesScore do
  describe '#call' do
    let(:user) { create(:user, vehicle: create(:vehicle), house: create(:house)) }

    context 'when all scores are calculated successfully' do
      it 'returns true' do
        allow(InsuranceManager::AutoInsurance).to receive(:call).and_return(true)
        allow(InsuranceManager::HomeInsurance).to receive(:call).and_return(true)
        allow(InsuranceManager::LifeInsurance).to receive(:call).and_return(true)
        allow(InsuranceManager::DisabilityInsurance).to receive(:call).and_return(true)

        service = described_class.new(user)
        result = service.call

        expect(result).to eq(true)
      end
    end

    context 'when one score calculation fails' do
      it 'returns false' do
        allow(InsuranceManager::LifeInsurance).to receive(:call).and_return(true)
        allow(InsuranceManager::AutoInsurance).to receive(:call).and_return(true)
        allow(InsuranceManager::HomeInsurance).to receive(:call).and_return(false) # Simulating failure
        allow(InsuranceManager::DisabilityInsurance).to receive(:call).and_return(true)

        service = described_class.new(user)
        result = service.call

        expect(result).to eq(false)
      end
    end
  end
end
