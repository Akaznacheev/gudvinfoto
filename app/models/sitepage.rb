# == Schema Information
#
# Table name: sitepages
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :string
#  question   :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sitepage < ActiveRecord::Base
end
