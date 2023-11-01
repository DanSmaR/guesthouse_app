class RemovePaymentMethodFromGuesthouse < ActiveRecord::Migration[7.1]
  def change
    remove_column :guesthouses, :payment_method, :integer
  end
end
