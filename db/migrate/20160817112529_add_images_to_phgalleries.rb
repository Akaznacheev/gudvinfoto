class AddImagesToPhgalleries < ActiveRecord::Migration
  def change
    add_column :phgalleries, :images, :json
  end
end
