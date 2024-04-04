FactoryBot.define do
  factory :vehicle do
    year { ::Faker::Number.between(from: 1900, to: Date.current.year ) }
    user { association(:user) }
  end
end
