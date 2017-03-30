class AddImgchecksToPhgalleries < ActiveRecord::Migration
  def change
    add_column :phgalleries, :imgchecks, :string, array: true, default: []
  end
end
