# == Schema Information
#
# Table name: socialicons
#
#  id         :integer          not null, primary key
#  name       :string
#  iconlink   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Socialicon < ActiveRecord::Base
end
