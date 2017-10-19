# == Schema Information
#
# Table name: deliveries
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :integer          default(0)
#  default    :string           default("НЕТ")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Delivery < ApplicationRecord
  has_many :orders
end
