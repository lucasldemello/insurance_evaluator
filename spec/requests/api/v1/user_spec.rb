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
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.keys).to contain_exactly('auto', 'disability', 'home', 'life')
        expect(parsed_response.values).to all(be_a(String))
      end

      context 'when user has no house, car, income and its older than 60s' do
        it 'return all ineligible' do
          post '/api/v1/user/evaluate_insurances', params: {
            age: 65,
            dependents: 0,
            marital_status: 'single',
            income: 0,
            risk_questions: [0, 0, 0]
          }

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          expect(parsed_response['auto']).to eq('inelegivel')
          expect(parsed_response['disability']).to eq('inelegivel')
          expect(parsed_response['home']).to eq('inelegivel')
          expect(parsed_response['life']).to eq('inelegivel')
        end
      end

      context 'when user has everything' do
        it 'returns all advanced' do
          post '/api/v1/user/evaluate_insurances', params: {
            age: 45,
            dependents: 1,
            marital_status: 'married',
            income: 30_000,
            risk_questions: [1, 1, 1],
            vehicle: { year: Date.current.year },
            house: { ownership_status: 'rented' }
          }

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          expect(parsed_response['auto']).to eq('avancado')
          expect(parsed_response['disability']).to eq('avancado')
          expect(parsed_response['home']).to eq('avancado')
          expect(parsed_response['life']).to eq('avancado')
        end
      end

      context 'when user score 1 or 2 in all products' do
        it 'return all standard' do
          post '/api/v1/user/evaluate_insurances', params: {
            age: 45,
            dependents: 0,
            marital_status: 'married',
            income: 30_000,
            risk_questions: [0, 0, 1],
            vehicle: { year: Date.current.year },
            house: { ownership_status: 'rented' }
          }

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          expect(parsed_response['auto']).to eq('padrao')
          expect(parsed_response['disability']).to eq('padrao')
          expect(parsed_response['home']).to eq('padrao')
          expect(parsed_response['life']).to eq('padrao')
        end
      end
    end

    context 'when some required parameters are missing' do
      it 'returns http error' do
        post '/api/v1/user/evaluate_insurances', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq(['Age is not a number', 'Dependents is not a number',
                                                'Income is not a number', "Marital status can't be blank"])
      end
    end
  end
end
