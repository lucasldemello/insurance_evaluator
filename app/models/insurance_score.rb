class InsuranceScore < ApplicationRecord
  belongs_to :user

  validates :insurance_type, presence: true
  validates :score_description, presence: true
end
