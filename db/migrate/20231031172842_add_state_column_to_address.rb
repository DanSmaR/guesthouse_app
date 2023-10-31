class AddStateColumnToAddress < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :state, :string
  end
end
