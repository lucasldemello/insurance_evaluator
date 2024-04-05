# frozen_string_literal: true

module InsuranceManager
  # Basic class to define the template for insurances
  # todo: move this for another place?
  class InsuranceStrategy < ApplicationService
    INELEGIBLE = 'inelegivel'
    STANDARD = 'padrao'
    ECONOMIC = 'economic'
    ADVANCED = 'avancado'

    attr_reader :user, :score

    def initialize(user)
      super()

      @user = user
    end

    # This method will store the type of insurance, if was ineligible and the score achieved (none if ineligible)
    # def call
    #   InsuranceScore.create(type: INSURANCE_TYPE, ineligible: is_ineligible, score: score)
    # end
    def call
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    private

    def insurance_type
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def is_ineligible
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # Will set the score
    def calculate_score
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def score_type
      return INELEGIBLE if is_ineligible

      return STANDARD if score.blank? || score <= 0

      return ECONOMIC if [1, 2].include?(score)

      ADVANCED # 3 or higher
    end
  end
end
