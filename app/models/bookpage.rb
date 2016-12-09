# == Schema Information
#
# Table name: bookpages
#
#  id         :integer          not null, primary key
#  pagenum    :integer
#  positions  :string
#  rotates    :string
#  bgcolor    :string           default("white")
#  template   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :json
#  book_id    :integer
#

class Bookpage < ActiveRecord::Base
  belongs_to      :book
  has_one         :phgallery
  serialize       :positions, Array
  serialize       :images
  mount_uploaders :images, ImageUploader
end
