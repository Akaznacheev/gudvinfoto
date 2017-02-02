require 'rest-client'
require 'json'
username ='akaznacheev'
last_item_id = '0'
instaurl = 'https://www.instagram.com/' + username + '/media/?max_id='
more_available = true
images = []
directory_name = "public/downloads/" + username + "/"
Dir.mkdir(directory_name) unless File.exists?(directory_name)
while more_available == true do
  response = RestClient.get instaurl+last_item_id
  parse = JSON.parse(response)
  items = parse["items"]
  items.each do |item|
    if item.key?("videos")
    else
      url = item["images"]["standard_resolution"]["url"]
      response = RestClient.get url
      if response.code == 200
        file_name = (images.count+1).to_s + "_" + rand(32**8).to_s(32) + '.jpg'
        File.write(directory_name + file_name, response.to_s)
      end
      images << url
    end
  end
  last_item_id = items.last["id"]
  more_available = parse["more_available"]
end

