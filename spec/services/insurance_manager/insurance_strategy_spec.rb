# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceManager::InsuranceStrategy do
  let(:user) { double('User') }

  describe '#call' do
    it 'raises NotImplementedError' do
      strategy = described_class.new(user)
      expect { strategy.call }.to raise_error(NotImplementedError)
    end
  end

  describe '#insurance_type' do
    it 'raises NotImplementedError' do
      strategy = described_class.new(user)
      expect { strategy.send(:insurance_type) }.to raise_error(NotImplementedError)
    end
  end

  describe '#ineligible?' do
    it 'raises NotImplementedError' do
      strategy = described_class.new(user)
      expect { strategy.send(:ineligible?) }.to raise_error(NotImplementedError)
    end
  end

  describe '#score' do
    it 'raises NotImplementedError' do
      strategy = described_class.new(user)
      expect { strategy.send(:calculate_score) }.to raise_error(NotImplementedError)
    end
  end

  describe '#score_type' do
    context 'when ineligible? is true' do
      it 'returns INELEGIBLE' do
        strategy = described_class.new(user)
        allow(strategy).to receive(:ineligible?).and_return(true)
        expect(strategy.send(:score_type)).to eq(described_class::INELEGIBLE)
      end
    end

    context 'when score is <= 0' do
      it 'returns STANDARD' do
        strategy = described_class.new(user)
        allow(strategy).to receive(:ineligible?).and_return(false)
        allow(strategy).to receive(:score).and_return(0)
        expect(strategy.send(:score_type)).to eq(described_class::STANDARD)
      end
    end

    context 'when score is between 1 and 2' do
      it 'returns ECONOMIC' do
        strategy = described_class.new(user)
        allow(strategy).to receive(:ineligible?).and_return(false)
        allow(strategy).to receive(:score).and_return(1)
        expect(strategy.send(:score_type)).to eq(described_class::ECONOMIC)
      end
    end

    context 'when score is 3 or higher' do
      it 'returns ADVANCED' do
        strategy = described_class.new(user)
        allow(strategy).to receive(:ineligible?).and_return(false)
        allow(strategy).to receive(:score).and_return(3)
        expect(strategy.send(:score_type)).to eq(described_class::ADVANCED)
      end
    end
  end
end
