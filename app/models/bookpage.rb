class Bookpage < ActiveRecord::Base
  belongs_to      :book
  belongs_to      :phgallery
end
