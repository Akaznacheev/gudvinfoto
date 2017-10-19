class AddImgchecksToPhgalleries < ActiveRecord::Migration[4.2]
  def change
    add_column :phgalleries, :imgchecks, :string, array: true, default: []
  end
end
