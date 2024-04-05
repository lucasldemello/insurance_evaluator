# frozen_string_literal: true

module InsuranceManager
  # Implements Life Insurance bussiness logic
  class LifeInsurance < InsuranceStrategy
    def call
      base_score
      adjust_score

      insurance_score = InsuranceScore.new({
                                             user:,
                                             insurance_type:,
                                             score:,
                                             score_description: score_type,
                                             ineligible: ineligible?
                                           })

      insurance_score.save
    end

    private

    def insurance_type
      'life'
    end

    def ineligible?
      user.age > 60
    end

    def adjust_score
      return if ineligible?

      @score += 1 unless user.dependents.zero?

      @score += 1 if user.married?
    end
  end
end
