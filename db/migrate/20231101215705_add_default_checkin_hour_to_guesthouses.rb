class AddDefaultCheckinHourToGuesthouses < ActiveRecord::Migration[7.1]
  def up
    change_column :guesthouses, :checkin_hour, :datetime, default: Time.parse("14:00")
    change_column :guesthouses, :checkout_hour, :datetime, default: Time.parse("12:00")
  end

  def down
    change_column :guesthouses, :checkin_hour, :datetime, default: nil
    change_column :guesthouses, :checkout_hour, :datetime, default: nil
  end
end
