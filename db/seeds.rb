# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

usertest = User.new(:email => 'test@example.com',
                    :password => 'testpass',
                    :password_confirmation => 'testpass')
usertest.save
puts 'CREATED TEST USER: ' << usertest.email

phgallery = Phgallery.create(:kind => "homepage")
puts 'CREATED PHGALLERY: ' << phgallery.kind

phgallery = Phgallery.create(:kind => "background")
puts 'CREATED PHGALLERY: ' << phgallery.kind

['facebook', 'instagram', 'vkontakte', 'youtube'].each do |item|
  socialicon = Socialicon.create(:name => item)
  puts 'CREATED SOCIALICON: ' << socialicon.name
end

bookprice = Bookprice.create(:format => "10см*10см",
                             :status => "НЕАКТИВЕН",
                             :default => "НЕТ",
                             :coverwidth => 3073,
                             :coverheight => 1570,
                             :twopagewidth => 2398,
                             :twopageheight => 1205,
                             :coverprice => 250,
                             :twopageprice => 50)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "15см*15см",
                             :default => "НЕТ",
                             :coverwidth => 4122,
                             :coverheight => 2150,
                             :twopagewidth => 3602,
                             :twopageheight => 1795,
                             :coverprice => 350,
                             :twopageprice => 90)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "20см*20см",
                             :default => "ПО УМОЛЧАНИЮ",
                             :coverwidth => 5315,
                             :coverheight => 2752,
                             :twopagewidth => 4795,
                             :twopageheight => 2398,
                             :coverprice => 450,
                             :twopageprice => 150)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "29см*29см",
                             :default => "НЕТ",
                             :coverwidth => 7640,
                             :coverheight => 4032,
                             :twopagewidth => 6850,
                             :twopageheight => 3425,
                             :coverprice => 550,
                             :twopageprice => 230)
puts 'CREATED BOOKPRICE: ' << bookprice.format

delivery = Delivery.create(:name => "На данный момент забрать можно только в офисе по адресу: г.Казань, ул. Короленко, д.35",
                           :default => "ДА")
puts 'CREATED DELIVERY: ' << delivery.name
