class AddAttributesToBookingModel < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :status, :integer, default: 0, null: false
    add_column :bookings, :registration_code, :integer, null: false
    add_column :bookings, :check_in_hour, :datetime, null: false
    add_column :bookings, :check_out_hour, :datetime, null: false
    add_column :bookings, :total_price, :integer, null: false
    change_column :bookings, :number_of_guests, :integer, null: false
    add_index :bookings, :registration_code, unique: true
  end
end
