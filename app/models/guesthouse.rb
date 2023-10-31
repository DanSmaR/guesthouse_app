class Guesthouse < ApplicationRecord
  belongs_to :address
  belongs_to :guesthouse_owner
end
