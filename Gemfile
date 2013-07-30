source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails'
gem 'gettext_i18n_rails'
gem 'haml-rails'
gem 'easy_auth', :github => 'stas/easy_auth', :branch => 'rails4'
gem 'easy_auth-oauth2', :github => 'dockyard/easy_auth-oauth2'
gem 'easy_auth-angel_list', :github => 'geekcelerator/easy_auth-angel_list'
gem 'readwritesettings'
gem 'oj'
gem 'sanitize'
gem 'active_model_serializers'
gem 'paperclip'
gem 'delayed_job', '4.0.0.beta2'
gem 'delayed_job_active_record', '4.0.0.beta3'
gem 'pg'
gem 'oembedr'

group :production do
  gem 'puma'
  gem 'party_foul'
  gem 'aws-sdk'
  gem 'intercom-rails'
  gem 'daemons'
end

group :assets do
  gem 'sprockets-rails'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'hamlbars'
  gem 'jquery-rails'
  gem 'ember-rails'
  gem 'handlebars-source', '1.0.12'
  gem 'ember-source', '1.0.0.rc6.2'
  gem 'bourbon'
  gem 'normalize-rails'
  gem 'pickadate-rails'
end

group :development do
  gem 'quiet_assets'
  gem 'seedbank', :github => 'james2m/seedbank'
  gem 'cane', :require => false
  gem 'yard', :require => false
  gem 'erd', :require => false
  gem 'mina', :require => false, :github => 'stas/mina', :branch => 'rbenv_and_ruby-build_support'
  gem 'simplecov', :require => false
  gem 'letter_opener'
  gem 'pry-rails'
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication'
  gem 'rspec-rails'
  gem 'guard-rspec', :require => false
  gem 'rb-inotify', :require => false
end

group :test do
  gem 'vcr'
  gem 'poltergeist'
  gem 'puffing-billy'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end
