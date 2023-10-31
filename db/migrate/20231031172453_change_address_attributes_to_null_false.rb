class ChangeAddressAttributesToNullFalse < ActiveRecord::Migration[7.1]
  def change
change_column_null :addresses, :street, false
    change_column_null :addresses, :neighborhood, false
    change_column_null :addresses, :city, false
    change_column_null :addresses, :postal_code, false
  end
end
