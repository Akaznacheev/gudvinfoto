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

Phgallery.create(kind: 'homepage')
Phgallery.create(kind: 'background')

%w[facebook instagram vkontakte youtube].each do |item|
  Socialicon.create(name: item)
end

Bookprice.create(format: '10см*10см',
                 status: 'НЕАКТИВЕН',
                 default: 'НЕТ',
                 coverwidth: 3073,
                 coverheight: 1570,
                 twopagewidth: 2398,
                 twopageheight: 1205,
                 coverprice: 250,
                 twopageprice: 50)

Bookprice.create(format: '15см*15см',
                 default: 'НЕТ',
                 coverwidth: 4122,
                 coverheight: 2150,
                 twopagewidth: 3602,
                 twopageheight: 1795,
                 coverprice: 350,
                 twopageprice: 90)

Bookprice.create(format: '20см*20см',
                 default: 'ПО УМОЛЧАНИЮ',
                 coverwidth: 5315,
                 coverheight: 2752,
                 twopagewidth: 4795,
                 twopageheight: 2398,
                 coverprice: 450,
                 twopageprice: 150)

Bookprice.create(format: '29см*29см',
                 default: 'НЕТ',
                 coverwidth: 7640,
                 coverheight: 4032,
                 twopagewidth: 6850,
                 twopageheight: 3425,
                 coverprice: 550,
                 twopageprice: 230)

Delivery.create(name: 'Отправка почтой или транспортной компанией',
                default: 'НЕТ')
Delivery.create(name: 'Самовывоз, г.Казань, ул. Короленко, д.35, офис Gudvin',
                default: 'ДА')