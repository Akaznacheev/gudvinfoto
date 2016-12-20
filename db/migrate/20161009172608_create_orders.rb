class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string    :name
      t.integer   :bookscount
      t.string    :fio
      t.string    :phone
      t.integer   :zipcode
      t.string    :city
      t.string    :address
      t.string    :email
      t.string    :comment
      t.integer   :price,         :default => 0
      t.string    :status,        :default => "Создан"

      t.timestamps null: false
    end
    add_reference :orders, :book, index: true, foreign_key: true
    add_reference :orders, :delivery, index: true, foreign_key: true
  end
end
