# == Schema Information
#
# Table name: bookpages
#
#  id         :integer          not null, primary key
#  pagenum    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  images     :json
#

class Bookpage < ActiveRecord::Base
  serialize   :images, Array
  belongs_to  :book
end
