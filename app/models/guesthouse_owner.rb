class GuesthouseOwner < ApplicationRecord
  belongs_to :user
  has_one :guesthouse
end
