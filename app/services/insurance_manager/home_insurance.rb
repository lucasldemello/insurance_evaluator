# frozen_string_literal: true

module InsuranceManager
  # Implements Home insurance bussiness_logic
  class HomeInsurance < InsuranceStrategy
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
      'home'
    end

    def ineligible?
      user.house.blank?
    end

    def adjust_score
      return if ineligible?

      @score += 1 if user.house.present? && user.house.rented?
    end
  end
end
