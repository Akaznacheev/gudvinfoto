source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'puma', '~> 3.7'
gem 'mina'
gem 'mina-puma',  require: false
gem 'mina-nginx', require: false
gem 'pg', '~> 0.21'
gem 'rails', '5.1.1'
gem 'rubyzip'
gem 'rubocop', require: false
# gem 'webpacker'

# gem 'rest-client', '~> 2.0'
gem 'will_paginate', '~> 3.1.0'
gem 'turbolinks'
gem 'jbuilder'
gem 'rails-i18n'

gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'carrierwave-imageoptimizer'
# gem 'carrierwave_backgrounder'
gem 'mini_magick', '~> 4.3'
gem 'rmagick', require: 'rmagick'

gem 'daemons'
gem 'delayed_job_active_record'

gem 'devise'
gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'pundit'

gem 'active_link_to'
gem 'font-awesome-sass', '~> 4.7.0'
gem 'bxslider-rails'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'sass_rails_patch'
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'better_errors'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
#  gem 'byebug'
#  gem 'factory_girl_rails'
#  gem 'faker'
#  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
