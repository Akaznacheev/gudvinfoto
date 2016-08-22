class AddImagesToBookpages < ActiveRecord::Migration
  def change
    add_column :bookpages, :images, :json
  end
end
