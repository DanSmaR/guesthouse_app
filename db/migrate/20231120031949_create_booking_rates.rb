class CreateBookingRates < ActiveRecord::Migration[7.1]
  def change
    create_table :booking_rates do |t|
      t.references :booking, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.decimal :rate, null: false

      t.timestamps
    end
  end
end
