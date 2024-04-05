FactoryBot.define do
  factory :insurance_score do
    user { association(:user) }
    insurance_type { 'life' }
    ineligible { false }
    score { 1 }
    score_description { %w[:ineligivel, :padrao] }
  end
end
