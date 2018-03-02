class FixColumnsNames < ActiveRecord::Migration[5.1]
  def self.up
    # rename books columns
    rename_column :books, :fontfamily, :font_family
    rename_column :books, :fontcolor, :font_color
    rename_column :books, :fontsize, :font_size
    rename_column :books, :bookprice_id, :price_list_id
    # rename book_pages columns
    rename_column :book_pages, :pagenum, :page_num
    rename_column :book_pages, :bgcolor, :background_color
    rename_column :book_pages, :phgallery_id, :gallery_id
    # rename galleries columns
    rename_column :galleries, :imgchecks, :added_images
    # rename orders columns
    rename_column :orders, :bookscount, :books_count
    rename_column :orders, :zipcode, :zip_code
    # rename price_lists columns
    rename_column :price_lists, :minpagescount, :min_pages_count
    rename_column :price_lists, :maxpagescount, :max_pages_count
    rename_column :price_lists, :coverprice, :cover_price
    rename_column :price_lists, :twopageprice, :twopage_price
    rename_column :price_lists, :coverwidth, :cover_width
    rename_column :price_lists, :coverheight, :cover_height
    rename_column :price_lists, :twopagewidth, :twopage_width
    rename_column :price_lists, :twopageheight, :twopage_height
    # rename social_icons columns
    rename_column :social_icons, :iconlink, :icon_link
  end
end
