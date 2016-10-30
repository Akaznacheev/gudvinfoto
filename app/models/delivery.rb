# == Schema Information
#
# Table name: deliveries
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Delivery < ActiveRecord::Base
  has_many :orders
end
