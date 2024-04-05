# frozen_string_literal: true

module InsuranceManager
  # Implements Auto Insurance bussiness logic
  class AutoInsurance < InsuranceStrategy
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
      'auto'
    end

    def ineligible?
      user.vehicle.blank?
    end

    def adjust_score
      return if ineligible?

      @score += 1 if user.vehicle.present? && user.vehicle.year.between?(Date.current.year - 5, Date.current.year)
    end
  end
end
