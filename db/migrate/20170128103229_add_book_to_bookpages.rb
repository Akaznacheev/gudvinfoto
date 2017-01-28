class AddBookToBookpages < ActiveRecord::Migration
  def change
    add_reference :bookpages, :book, index: true, foreign_key: true
  end
end
