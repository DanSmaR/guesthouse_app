class AddAttributesToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :check_in_confirmed_date, :date
    add_column :bookings, :check_out_confirmed_date, :date
    add_column :bookings, :check_in_confirmed_hour, :datetime
    add_column :bookings, :check_out_confirmed_hour, :datetime
    add_column :bookings, :total_paid, :integer
  end
end
