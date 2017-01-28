class AddBookToPhgalleries < ActiveRecord::Migration
  def change
    add_reference :phgalleries, :book, index: true, foreign_key: true
  end
end
