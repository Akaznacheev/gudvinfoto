class AddKindToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :kind, :string, default: 'book'
    add_column :orders, :holst_id, :integer
  end
end
