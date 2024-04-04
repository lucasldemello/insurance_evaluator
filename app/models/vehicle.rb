class Vehicle < ApplicationRecord
  belongs_to :user

  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1800, less_than_or_equal_to: Date.current.year }
end
