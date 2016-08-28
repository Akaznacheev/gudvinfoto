# == Schema Information
#
# Table name: phgalleries
#
#  id         :integer          not null, primary key
#  kind       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :json
#  book_id    :integer
#

class Phgallery < ActiveRecord::Base
  belongs_to      :book
  serialize       :images, Array
  mount_uploaders :images, ImageUploader
end
