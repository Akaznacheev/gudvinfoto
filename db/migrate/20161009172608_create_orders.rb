class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.string    :name
      t.integer   :bookscount, default: 0
      t.string    :fio
      t.string    :phone
      t.integer   :zipcode, default: 0
      t.string    :city
      t.string    :address
      t.string    :email
      t.string    :comment
      t.integer   :price,         default: 0
      t.string    :status,        default: 'Создан'
      t.timestamps null: false
    end
  end
end
