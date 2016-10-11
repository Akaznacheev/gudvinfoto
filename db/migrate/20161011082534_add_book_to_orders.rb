class AddBookToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :book, index: true, foreign_key: true
  end
end
