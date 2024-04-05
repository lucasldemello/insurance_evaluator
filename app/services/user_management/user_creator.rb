# frozen_string_literal: true

module UserManagement
  # This class is responsible for creating users within it`s dependences
  class UserCreator < ApplicationService
    attr_reader :user_params, :vehicle_params, :house_params

    def initialize(user_params, vehicle_params, house_params)
      super()

      @user_params = user_params
      @vehicle_params = vehicle_params
      @house_params = house_params
    end

    def call
      user = User.new(@user_params)
      user.build_vehicle(@vehicle_params)
      user.build_house(@house_params)

      user.save
    end
  end
end
