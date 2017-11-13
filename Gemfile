source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.2"
gem "mysql2"
gem "puma", "~> 3.0"
gem "sass-rails"
gem "bootstrap-sass"
gem "jquery-rails"
gem "redis", "~> 3.0"
gem "devise"
gem "carrierwave"
gem "chess", git: "http://github.com/edpaget/chess-rules.git"
# gem "capistrano-rails", group: :development

group :development, :test do
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.0.5"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
