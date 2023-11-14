class RoomRate < ApplicationRecord
  validates :daily_rate, :start_date, :end_date, presence: true
  validates :daily_rate, numericality: { greater_than: 0 }
  belongs_to :room

  validate :dates_not_overlapping

  private

  # TODO: refactor this method, must be <= comparison
  # TODO: add unit testing to models
  def dates_not_overlapping
    return if RoomRate.where.not(id: id).where(room_id: room_id)
                      .where('start_date <= ? AND end_date >= ?',
                             end_date, start_date).none?

    errors.add(:base, 'Essas datas estão sobrepostas a uma diária já cadastrada')
  end
end
