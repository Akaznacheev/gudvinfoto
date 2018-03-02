# == Schema Information
#
# Table name: galleries
#
#  id           :integer          not null, primary key
#  kind         :string           default("book")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  images       :string           default([]), is an Array
#  book_id      :integer
#  added_images :string           default([]), is an Array
#

class Gallery < ApplicationRecord
  belongs_to :book, optional: true
  has_many :book_pages, -> { order(created_at: :asc) }
  mount_uploaders :images, ImageUploader
end
