class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :neighborhood
      t.string :city
      t.string :postal_code

      t.timestamps
    end
  end
end
