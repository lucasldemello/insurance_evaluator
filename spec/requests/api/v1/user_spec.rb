# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /evaluate_insurances' do
    context 'when all required parameters are provided' do
      it 'returns http success' do
        post '/api/v1/user/evaluate_insurances', params: {
          age: 35,
          dependents: 2,
          marital_status: 'married',
          income: 0,
          vehicle: { year: 2018 },
          house: { ownership_status: 'owned' }
        }

        expect(response).to have_http_status(:success)
      end
    end

    context 'when some required parameters are missing' do
      it 'returns http error' do
        post '/api/v1/user/evaluate_insurances', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Failed to evaluate insurances')
      end
    end
  end
end
