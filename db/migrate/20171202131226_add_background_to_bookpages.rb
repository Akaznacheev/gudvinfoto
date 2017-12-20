class AddBackgroundToBookpages < ActiveRecord::Migration[5.1]
  def change
    add_column :bookpages, :background, :string
  end
end
