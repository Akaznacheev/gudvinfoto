# == Schema Information
#
# Table name: bookprices
#
#  id         :integer          not null, primary key
#  format     :string
#  cover      :integer
#  page       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bookprice < ActiveRecord::Base
end
