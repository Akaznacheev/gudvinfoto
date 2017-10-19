class AddPhgalleryToBookpages < ActiveRecord::Migration[4.2]
  def change
    add_reference :bookpages, :phgallery, index: true, foreign_key: true
  end
end
