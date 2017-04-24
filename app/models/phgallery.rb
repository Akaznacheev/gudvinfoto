# == Schema Information
#
# Table name: phgalleries
#
#  id         :integer          not null, primary key
#  kind       :string           default("book")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :string           default([]), is an Array
#  book_id    :integer
#  imgchecks  :string           default([]), is an Array
#

class Phgallery < ActiveRecord::Base
  belongs_to      :book
  has_many        :bookpage
  mount_uploaders :images, ImageUploader
end
