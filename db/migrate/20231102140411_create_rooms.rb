class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.text :description
      t.integer :size, null: false
      t.integer :max_people, null: false
      t.decimal :daily_rate, null: false
      t.boolean :bathroom, null: false, default: false
      t.boolean :balcony, null: false, default: false
      t.boolean :air_conditioning, null: false, default: false
      t.boolean :tv, null: false, default: false
      t.boolean :wardrobe, null: false, default: false
      t.boolean :safe, null: false, default: false
      t.boolean :accessible, null: false, default: false
      t.boolean :available, null: false, default: true
      t.references :guesthouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
