class Phgallery < ActiveRecord::Base
  belongs_to      :book
  has_many        :bookpage
  mount_uploaders :images, ImageUploader
end
