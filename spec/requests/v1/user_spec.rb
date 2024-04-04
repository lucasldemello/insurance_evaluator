require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  describe "POST /evaluate_insurances" do
    it "returns http success" do
      post "/v1/user/evaluate_insurances"
      expect(response).to have_http_status(:success)
    end
  end

end
