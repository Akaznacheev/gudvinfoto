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

class Phgallery < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to      :book, optional: true
  has_many        :bookpage, -> { order(created_at: :asc) }
  mount_uploaders :images, ImageUploader
  # one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:avatar),
      "size" => avatar.size,
      "url" => avatar.url,
      "thumbnail_url" => avatar.thumb.url,
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end
