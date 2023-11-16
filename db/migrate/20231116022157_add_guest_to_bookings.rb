class AddGuestToBookings < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookings, :guest, null: false, foreign_key: true
  end
end
