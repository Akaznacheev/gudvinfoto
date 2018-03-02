# == Schema Information
#
# Table name: changes
#
#  id          :integer          not null, primary key
#  description :string
#  kind        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Change < ApplicationRecord
  default_scope { order(created_at: :desc) }
  validates :description, presence: true

  def date
    created_at.strftime('(%Y/%m/%d)')
  end

  def choose_emoji
    case kind
    when 'Bug'
      '🐛'
    when 'New'
      '⭐'
    else
      '⚙'
    end
  end
end
