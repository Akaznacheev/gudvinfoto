class AddLinksToPartners < ActiveRecord::Migration[5.1]
  def change
    add_column :partners, :link, :string
  end
end
