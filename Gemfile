source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'mina'
gem 'mina-nginx', require: false
gem 'mina-puma',  require: false
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'rubyzip'
# gem 'webpacker'

gem 'jbuilder', '~> 2.5'
gem 'rails-i18n'
gem 'will_paginate', '~> 3.1.0'

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
gem 'jquery-rails'
gem 'jquery-slick-rails'
gem 'sass-rails', '~> 5.0'
gem 'sass_rails_patch'
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  #  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  #  gem 'capybara', '~> 2.13'
  #  gem 'selenium-webdriver'
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
