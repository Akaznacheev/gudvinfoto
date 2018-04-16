# == Schema Information
#
# Table name: price_lists
#
#  id              :integer          not null, primary key
#  format          :string
#  status          :string           default("АКТИВЕН")
#  default         :string           default("НЕТ")
#  min_pages_count :integer          default(20)
#  max_pages_count :integer          default(30)
#  cover_price     :integer          default(0)
#  twopage_price   :integer          default(0)
#  cover_width     :integer          default(0)
#  cover_height    :integer          default(0)
#  twopage_width   :integer          default(0)
#  twopage_height  :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  kind            :string           default("book")
#  holst_price     :integer          default(0)
#

class PriceList < ApplicationRecord
  default_scope { order(created_at: :asc) }
  has_many :books, -> { order(created_at: :asc) }
end
