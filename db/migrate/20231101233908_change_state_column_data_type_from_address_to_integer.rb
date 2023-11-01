class ChangeStateColumnDataTypeFromAddressToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :addresses, :state, :integer
  end
end
