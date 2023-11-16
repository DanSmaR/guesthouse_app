class CreateGuests < ActiveRecord::Migration[7.1]
  def change
    create_table :guests do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :identification_register_number, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
