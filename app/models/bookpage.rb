# == Schema Information
#
# Table name: bookpages
#
#  id           :integer          not null, primary key
#  pagenum      :integer          default(0)
#  bgcolor      :string           default("white")
#  template     :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  images       :string           default([]), is an Array
#  positions    :string           default([]), is an Array
#  book_id      :integer
#  phgallery_id :integer
#

class Bookpage < ApplicationRecord
  belongs_to      :book
  belongs_to      :phgallery
end
