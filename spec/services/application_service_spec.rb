# frozen_string_literal: true

# spec/services/application_service_spec.rb
require 'rails_helper'

RSpec.describe ApplicationService do
  class SillyService < ApplicationService
    def initialize(arg1, arg2)
      @arg1 = arg1
      @arg2 = arg2
    end

    def call
      [@arg1, @arg2].join(' ')
    end
  end

  describe '.call' do
    it 'creates a new instance of the service and calls the call method' do
      expect_any_instance_of(SillyService).to receive(:call).and_call_original
      SillyService.call('arg1', 'arg2')
    end

    it 'return the two args together' do
      expect(SillyService.call('Dwight', 'Schrute')).to eq('Dwight Schrute')
    end

    it 'returns the result of calling the call method' do
      allow_any_instance_of(SillyService).to receive(:call).and_return('result')
      expect(SillyService.call('arg1', 'arg2')).to eq('result')
    end
  end
end