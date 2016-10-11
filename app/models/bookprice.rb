# == Schema Information
#
# Table name: bookprices
#
#  id                :integer          not null, primary key
#  format            :string
#  status            :string
#  default           :boolean
#  defaultpagescount :integer          default(20)
#  cover             :integer
#  page              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Bookprice < ActiveRecord::Base
end
