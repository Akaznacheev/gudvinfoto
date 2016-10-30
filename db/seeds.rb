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
phgallery.save
puts 'CREATED PHGALLERY: ' << phgallery.kind

socialicon1 = Socialicon.create(:name => "facebook")
socialicon1.save
puts 'CREATED SOCIALICON: ' << socialicon1.name
socialicon2 = Socialicon.create(:name => "instagram")
socialicon2.save
puts 'CREATED SOCIALICON: ' << socialicon2.name
socialicon3 = Socialicon.create(:name => "vkontakte")
socialicon3.save
puts 'CREATED SOCIALICON: ' << socialicon3.name
socialicon4 = Socialicon.create(:name => "youtube")
socialicon4.save
puts 'CREATED SOCIALICON: ' << socialicon4.name
