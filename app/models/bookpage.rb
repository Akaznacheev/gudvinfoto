# == Schema Information
#
# Table name: bookpages
#
#  id         :integer          not null, primary key
#  pagenum    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :array            default("--- []\n")
#  book_id    :integer
#

class Bookpage < ActiveRecord::Base
  belongs_to      :book
  has_one         :phgallery
  serialize       :images
  mount_uploaders :images, ImageUploader
end
