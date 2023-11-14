class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.date :check_in_date, null: false
      t.date :check_out_date, null: false
      t.integer :number_of_guests, null: false
      t.belongs_to :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
