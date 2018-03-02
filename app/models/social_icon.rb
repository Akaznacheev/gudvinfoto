# == Schema Information
#
# Table name: social_icons
#
#  id         :integer          not null, primary key
#  name       :string
#  icon_link  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SocialIcon < ApplicationRecord
end
