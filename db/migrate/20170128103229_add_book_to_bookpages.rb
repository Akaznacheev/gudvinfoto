class AddBookToBookpages < ActiveRecord::Migration[4.2]
  def change
    add_reference :bookpages, :book, index: true, foreign_key: true
  end
end
