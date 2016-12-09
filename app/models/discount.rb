# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Discount < ActiveRecord::Base
end
