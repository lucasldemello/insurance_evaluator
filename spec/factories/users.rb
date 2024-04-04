FactoryBot.define do
  factory :user do
    age { Faker::Number.between(from: 18, to: 65) }
    dependents { Faker::Number.between(from: 0, to: 5) }
    income { Faker::Number.between(from: 1000, to: 10000) }
    marital_status { %w[single married].sample }
    risk_questions { Array.new(3) { Faker::Number.between(from: 0, to: 1) } }
  end
end
