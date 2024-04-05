# frozen_string_literal: true

module V1
  # Class responsible for processing the user evaluation of insurances.
  class UserController < ApplicationController
    def evaluate_insurances
      result = UserManagement::UserCreator.call(user_params, vehicle_params, house_params)

      return render json: { message: 'Insurance evaluation successful' }, status: :ok if result

      render json: { error: 'Failed to evaluate insurances' }, status: :unprocessable_entity
    end

    private

    def user_params
      params.permit(
        :age,
        :dependents,
        :marital_status,
        :income
      )
    end

    def vehicle_params
      params[:vehicle]&.permit(:year)
    end

    def house_params
      params[:house]&.permit(:ownership_status)
    end
  end
end
