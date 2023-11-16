class ChangeRegistrationCodeNameFromBookingsTable < ActiveRecord::Migration[7.1]
  def change
    rename_column :bookings, :registration_code, :reservation_code
  end
end
