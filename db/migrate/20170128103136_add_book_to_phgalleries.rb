class AddBookToPhgalleries < ActiveRecord::Migration[4.2]
  def change
    add_reference :phgalleries, :book, index: true, foreign_key: true
  end
end
