class CreateGuesthouseOwners < ActiveRecord::Migration[7.1]
  def change
    create_table :guesthouse_owners do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
