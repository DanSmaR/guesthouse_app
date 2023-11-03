class CreateRoomRates < ActiveRecord::Migration[7.1]
  def change
    create_table :room_rates do |t|
      t.date :start_date
      t.date :end_date
      t.decimal :daily_rate, null: false, default: 0.0
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
