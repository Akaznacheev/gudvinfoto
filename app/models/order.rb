# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  name       :string
#  bookscount :integer
#  fio        :string
#  phone      :string
#  zipcode    :integer
#  city       :string
#  address    :string
#  email      :string
#  comment    :string
#  delivery   :string
#  price      :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
end
