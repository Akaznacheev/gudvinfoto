# == Schema Information
#
# Table name: bookpages
#
#  id         :integer          not null, primary key
#  pagenum    :integer
#  positions  :string
#  bgcolor    :string           default("white")
#  template   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :json
#  book_id    :integer
#

class Bookpage < ActiveRecord::Base
  belongs_to      :book
  belongs_to         :phgallery
end