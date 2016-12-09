# == Schema Information
#
# Table name: bookprices
#
#  id            :integer          not null, primary key
#  format        :string
#  status        :string           default("АКТИВЕН")
#  default       :string           default("НЕТ")
#  minpagescount :integer          default(20)
#  maxpagescount :integer          default(30)
#  coverprice    :integer          default(0)
#  twopageprice  :integer          default(0)
#  coverwidth    :integer          default(0)
#  coverheight   :integer          default(0)
#  twopagewidth  :integer          default(0)
#  twopageheight :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Bookprice < ActiveRecord::Base
  has_many :books
end
