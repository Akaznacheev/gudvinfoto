class AddBookToOrders < ActiveRecord::Migration[4.2]
  def change
    add_reference :orders, :book, index: true, foreign_key: true
  end
end
