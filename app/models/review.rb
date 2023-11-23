class Review < ApplicationRecord
  belongs_to :guest
  belongs_to :booking

  enum rating: { terrible: 0, bad: 1, regular: 2, good: 3, very_good: 4, great: 5 }

  validates :rating, presence: true, inclusion: { in: ratings.keys }
  validates :response, presence: true, length: { maximum: 500 }, on: :update
end
