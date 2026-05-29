class AddDeliveryAndPaymentToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :delivery_method, :string
    add_column :orders, :payment_method, :string
  end
end
