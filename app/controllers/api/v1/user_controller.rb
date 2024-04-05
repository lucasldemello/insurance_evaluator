# frozen_string_literal: true

module Api
  module V1
    # Class responsible for processing the user evaluation of insurances.
    class UserController < ApplicationController
      def evaluate_insurances
        create_user

        return process_insurances if @user.valid?

        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def create_user
        @user = UserManagement::UserCreator.call(user_params, vehicle_params, house_params)
      end

      def process_insurances
        result = InsuranceManager::CalculateInsurancesScore.call(@user)

        return render json: { message: 'Insurance evaluation successful', user: @user }, status: :ok if result

        render json: { error: 'Failed to evaluate insurances' }, status: :unprocessable_entity
      end

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
end
