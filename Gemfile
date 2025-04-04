source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "2.7.4"

gem "aasm", "~> 5.1"
gem "active_interaction", "~> 4.0"
gem "acts_as_paranoid", "~> 0.7.3"
gem "amazing_print", "~> 1.3"
gem "auto_strip_attributes", "~> 2.6"
gem "aws-sdk-s3", "~> 1.114"
gem "bootsnap", ">= 1.4.2", require: false
gem "devise", "~> 4.7"
gem "fx", "~> 0.6.2"
gem "image_processing", "~> 1.12"
gem "jbuilder", "~> 2.7"
gem "pagy", "~> 5.10"
gem "pg", ">= 0.18", "< 2.0"
gem "pg_search", "~> 2.3"
gem "phonelib", "~> 0.6.48"
gem "puma", "~> 5.6"
gem "rails", "~> 6.1"
gem "ransack", github: "activerecord-hackery/ransack"
gem "react-rails", "~> 2.6"
gem "rollbar", "~> 3.3"
gem "sass-rails", ">= 6"
gem "sendgrid-actionmailer", "~> 3.2"
gem "smarter_csv", "~> 1.2"
gem "twilio-ruby"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails", "~> 6.1"
  gem "ffaker", "~> 2.18"
  gem "timecop", "~> 0.9.4"
end

group :development do
  gem "listen", "~> 3.2"
  gem "rubocop", "~> 1.24"
  gem "rubocop-performance", "~> 1.13"
  gem "rubocop-rails", "~> 2.13"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"

  # After 8/10/23 `bundle update webdrivers`:
  #    Webdrivers gem update options
  #  *****************************
  #  Selenium itself now manages drivers by default: https://www.selenium.dev/documentation/selenium_manager
  #  * If you are using Ruby 3+ — please update to Selenium 4.11+ and stop requiring this gem
  #  * If you are using Ruby 2.6+ and Selenium 4.0+ — this version will work for now
  #  * If you use Ruby < 2.6 or Selenium 3, a 6.0 version of this gem with additional support is planned
  #  Restrict your gemfile to "webdrivers", "= 5.3.0" to stop seeing this message
  gem "webdrivers"
end

gem "sendgrid-ruby", "~> 6.6"
