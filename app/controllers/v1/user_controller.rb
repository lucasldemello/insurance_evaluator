# frozen_string_literal: true

module V1
  class UserController < ApplicationController
    def evaluate_insurances
      render json: {}, status: :ok
    end

    private

    def user_params
      params.permit(
        :age,
        :dependents,
        :marital_status,
        :income,
        house: [:ownership_status],
        vehicle: [:year]
      )
    end
  end
end
