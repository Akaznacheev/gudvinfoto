class FixTablesNames < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :bookpages, :book_pages
    rename_table :bookprices, :price_lists
    rename_table :phgalleries, :galleries
    rename_table :socialicons, :social_icons
  end
end
