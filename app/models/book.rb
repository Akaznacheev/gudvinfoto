# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  price        :integer          default(0)
#  name         :string           default("My photobook")
#  fontfamily   :string           default("PT Sans")
#  fontcolor    :string           default("black")
#  fontsize     :string           default("6")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  bookprice_id :integer
#

class Book < ActiveRecord::Base
  belongs_to  :user
  has_many    :bookpages, dependent: :destroy
  has_one     :phgallery, dependent: :destroy
  has_one     :order, dependent: :destroy
  belongs_to  :bookprice
end
