# == Schema Information
#
# Table name: phgalleries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :json
#

class Phgallery < ActiveRecord::Base
  belongs_to      :book
  serialize       :images, Array
  mount_uploaders :images, ImageUploader
end
