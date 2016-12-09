# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

phgallery = Phgallery.create(:kind => "homepage")
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
                             :twopageheight => 1205)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "15см*15см",
                             :default => "НЕТ",
                             :coverwidth => 4122,
                             :coverheight => 2150,
                             :twopagewidth => 3602,
                             :twopageheight => 1795)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "20см*20см",
                             :default => "ПО УМОЛЧАНИЮ",
                             :coverwidth => 5315,
                             :coverheight => 2752,
                             :twopagewidth => 4795,
                             :twopageheight => 2398)
puts 'CREATED BOOKPRICE: ' << bookprice.format

bookprice = Bookprice.create(:format => "29см*29см",
                             :default => "НЕТ",
                             :coverwidth => 7640,
                             :coverheight => 4032,
                             :twopagewidth => 6850,
                             :twopageheight => 3425)
puts 'CREATED BOOKPRICE: ' << bookprice.format

delivery = Delivery.create(:name => "На данный момент забрать можно только в офисе по адресу: г.Казань, ул. Короленко, д.35",
                           :default => "ДА")
puts 'CREATED DELIVERY: ' << delivery.name
