class ChangeRegistrationCodeDataTypeFromBookingsToString < ActiveRecord::Migration[7.1]
  def change
    change_column :bookings, :registration_code, :string, null: false
  end
end
