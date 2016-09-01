# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  pagecount  :integer
#  name       :string           default("My photobook")
#  fontfamily :string           default("PT Sans")
#  fontcolor  :string           default("black")
#  fontsize   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Book < ActiveRecord::Base
  belongs_to  :user
  has_many    :bookpages
  has_one     :phgallery

  BPCOUNT = 20
end
