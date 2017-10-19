class CreateBooks < ActiveRecord::Migration[4.2]
  def change
    create_table  :books do |t|
      t.integer   :price,         default: 0
      t.string    :name,          default: 'My photobook'
      t.string    :fontfamily,    default: 'PT Sans'
      t.string    :fontcolor,     default: 'black'
      t.string    :fontsize,      default: 6

      t.timestamps null: false
    end
  end
end
