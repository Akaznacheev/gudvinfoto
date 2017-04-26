# == Schema Information
#
# Table name: partners
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  attachment  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Partner < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  # validates :name, presence: true
end
