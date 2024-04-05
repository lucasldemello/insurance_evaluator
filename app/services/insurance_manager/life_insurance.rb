# frozen_string_literal: true

module InsuranceManager
  class LifeInsurance < InsuranceStrategy
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
      'life'
    end

    def ineligible?
      user.age > 60
    end

    def calculate_score
      return if ineligible?

      score = user.standard_risk_score

      # Se o usuário tem menos de 30 anos, diminua 2 pontos de risco de todas as linhas de seguro. Se ele tiver entre 30 e 40, diminua 1
      score -= 2 if user.age < 30
      score -= 1 if user.age.between?(30, 40)

      # Se a renda for superior a 200k, diminua 1 ponto de risco de todas as linhas de seguro.
      score -= 1 if user.income > 200_000

      # Se o usuário tem dependentes, adicione 1 ponto em ambos os riscos de invalidez e vida.
      score += 1 unless user.dependents.zero?

      # Se o usuario for casado, adicione 1 ponto em vida, e remova 1 ponto em invalidez.
      score += 1 if user.married?

      @score = score
    end
  end
end
