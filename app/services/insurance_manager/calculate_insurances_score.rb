# frozen_string_literal: true

module InsuranceManager
  # Implements the service responsible to calc all insurance types
  class CalculateInsurancesScore < ApplicationService
    attr_reader :user

    def initialize(user)
      super()
      @user = user
    end

    def call
      results = insurance_types.map do |type|
        class_name = "InsuranceManager::#{type}Insurance"
        Object.const_get(class_name).call(@user)
      end

      results.all?
    end

    private

    def insurance_types
      %w[Life Auto House Disability]
    end
  end
end
