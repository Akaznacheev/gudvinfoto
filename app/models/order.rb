# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  name        :string
#  bookscount  :integer
#  fio         :string
#  phone       :string
#  zipcode     :integer
#  city        :string
#  address     :string
#  email       :string
#  comment     :string
#  price       :integer          default(0)
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :integer
#  delivery_id :integer
#

class Order < ActiveRecord::Base
  belongs_to      :book
  belongs_to      :delivery
end
