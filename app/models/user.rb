class User < ApplicationRecord
  enum :marital_status, single: 'single', married: 'married'

  has_one :vehicle, required: false
  has_one :house, required: false
  has_many :insurance_scores

  validates :age, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :dependents, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :income, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :marital_status, presence: true
  validates :risk_questions, presence: true
  validate :validate_risk_questions_array

  private

  def validate_risk_questions_array
    if risk_questions.is_a?(Array) && risk_questions.length == 3 && risk_questions.all? { |q| [0, 1].include?(q&.to_i) }
      true
    else
      errors.add(:risk_questions, 'must be an array with 3 boolean values')
    end
  end
end
