# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CreateAdminService.new.call
User.create(email: 'test@example.com',
            password: 'testpass',
            password_confirmation: 'testpass')

Gallery.create(kind: 'homepage')
Gallery.create(kind: 'background')

%w[facebook instagram vkontakte youtube].each do |item|
  SocialIcon.create(name: item)
end

PriceList.create(format: '10см*10см',
                 status: 'НЕАКТИВЕН',
                 default: 'НЕТ',
                 cover_width: 3073,
                 cover_height: 1570,
                 twopage_width: 2398,
                 twopage_height: 1205,
                 cover_price: 250,
                 twopage_price: 50)

PriceList.create(format: '15см*15см',
                 default: 'НЕТ',
                 cover_width: 4122,
                 cover_height: 2150,
                 twopage_width: 3602,
                 twopage_height: 1795,
                 cover_price: 350,
                 twopage_price: 90)

PriceList.create(format: '20см*20см',
                 default: 'ПО УМОЛЧАНИЮ',
                 cover_width: 5315,
                 cover_height: 2752,
                 twopage_width: 4795,
                 twopage_height: 2398,
                 cover_price: 450,
                 twopage_price: 150)

PriceList.create(format: '29см*29см',
                 default: 'НЕТ',
                 cover_width: 7640,
                 cover_height: 4032,
                 twopage_width: 6850,
                 twopage_height: 3425,
                 cover_price: 550,
                 twopage_price: 230)

Delivery.create(name: 'Отправка почтой или транспортной компанией',
                default: 'НЕТ')
Delivery.create(name: 'Самовывоз, г.Казань, ул. Короленко, д.35, офис Gudvin',
                default: 'ДА')
