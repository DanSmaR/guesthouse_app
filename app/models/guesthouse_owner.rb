class GuesthouseOwner < ApplicationRecord
  belongs_to :user, optional: true
  has_one :guesthouse
end
