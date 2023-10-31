class AddPaymentMethodAttributeToGuesthouses < ActiveRecord::Migration[7.1]
  def change
    add_column :guesthouses, :payment_method, :integer
  end
end
