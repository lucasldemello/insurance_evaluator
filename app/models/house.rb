class House < ApplicationRecord
  enum :ownership_status, owned: 'owned', rented: 'rented'
  belongs_to :user

  validates :ownership_status, presence: true
end
