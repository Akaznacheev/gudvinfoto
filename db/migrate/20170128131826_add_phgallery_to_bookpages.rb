class AddPhgalleryToBookpages < ActiveRecord::Migration
  def change
    add_reference :bookpages, :phgallery, index: true, foreign_key: true
  end
end
