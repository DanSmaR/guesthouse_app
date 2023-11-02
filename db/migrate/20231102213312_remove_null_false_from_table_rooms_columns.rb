class RemoveNullFalseFromTableRoomsColumns < ActiveRecord::Migration[7.1]
  def change
    change_column_null :rooms, :bathroom, true
    change_column_null :rooms, :balcony, true
    change_column_null :rooms, :air_conditioning, true
    change_column_null :rooms, :tv, true
    change_column_null :rooms, :wardrobe, true
    change_column_null :rooms, :safe, true
    change_column_null :rooms, :accessible, true
    change_column_null :rooms, :available, true
  end
end
