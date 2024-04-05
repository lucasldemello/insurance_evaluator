# frozen_string_literal: true

module InsuranceScores
  # This class will build the response serialized for the request on insurance scores
  class InsuranceScoreSerializer < ApplicationSerializer
    attr_reader :user

    def initialize(user)
      super()
      @user = user
    end

    def as_json
      user.insurance_scores.order(:insurance_type).pluck(:insurance_type, :score_description).to_h
    end
  end
end
