# frozen_string_literal: true

module InsuranceManager
  class HouseInsurance < InsuranceStrategy
    def call
      calculate_score

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
      'house'
    end

    def ineligible?
      user.house.blank?
    end

    def calculate_score
      return if ineligible?

      score = user.standard_risk_score

      # Se o usuário tem menos de 30 anos, diminua 2 pontos de risco de todas as linhas de seguro. Se ele tiver entre 30 e 40, diminua 1
      score -= 2 if user.age < 30
      score -= 1 if user.age.between?(30, 40)

      # Se a renda for superior a 200k, diminua 1 ponto de risco de todas as linhas de seguro.
      score -= 1 if user.income > 200_000

      # Se a casa do usuário é alugada, adicione 1 ponto de risco no seguro residencial e de invalidez
      score += 1 if user.house.rented?

      @score = score
    end
  end
end
