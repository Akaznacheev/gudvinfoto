# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  pagecount  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ActiveRecord::Base
  belongs_to :user
  has_many  :bookpages
  has_one   :phgallery
end
