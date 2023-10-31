class CreateGuesthouses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesthouses do |t|
      t.string :corporate_name, null: false
      t.string :brand_name, null: false
      t.string :registration_code, null: false
      t.string :phone_number, null: false
      t.string :email, null: false
      t.references :address, null: false, foreign_key: true
      t.references :guesthouse_owner, null: false, foreign_key: true
      t.text :description
      t.boolean :pets, default: false
      t.text :use_policy
      t.time :checkin_hour
      t.time :checkout_hour
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
