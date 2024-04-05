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
    #   InsuranceScore.create(type: INSURANCE_TYPE, ineligible: ineligible?, score: score)
    # end
    def call
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    private

    def insurance_type
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def ineligible?
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # Will set the score
    def adjust_score
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def base_score
      return if ineligible?

      score = user.standard_risk_score

      # Se o usuário tem menos de 30 anos, diminua 2 pontos de risco de todas as linhas de seguro. Se ele tiver entre 30 e 40, diminua 1
      score -= 2 if user.age < 30
      score -= 1 if user.age.between?(30, 40)

      # Se a renda for superior a 200k, diminua 1 ponto de risco de todas as linhas de seguro.
      score -= 1 if user.income > 200_000

      @score = score
    end

    def score_type
      return INELEGIBLE if ineligible?

      return STANDARD if score.blank? || score <= 0

      return ECONOMIC if [1, 2].include?(score)

      ADVANCED # 3 or higher
    end
  end
end
