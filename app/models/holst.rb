# == Schema Information
#
# Table name: holsts
#
#  id            :integer          not null, primary key
#  format        :string
#  price         :integer
#  image         :string
#  positions     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price_list_id :integer
#  user_id       :integer
#

class Holst < ApplicationRecord
  belongs_to :user
  belongs_to :price_list
  mount_uploader :image, ImageUploader

  def holst_image_rotate(holst, rotate)
    image_object = holst.image
    file_image_rotate(image_object, rotate)
    holst.positions = '0px 0px'
    holst.save
  end

  def file_image_rotate(image_object, rotate)
    url_files_to_rotate = [image_object.thumb.path, image_object.ineditor.path, image_object.path]
    url_files_to_rotate.each do |url|
      image_file = Magick::Image.read(url).first
      image_file.rotate!(rotate).write(url)
    end
  end
end
