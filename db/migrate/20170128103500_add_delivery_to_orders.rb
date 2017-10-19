class AddDeliveryToOrders < ActiveRecord::Migration[4.2]
  def change
    add_reference :orders, :delivery, index: true, foreign_key: true
  end
end
