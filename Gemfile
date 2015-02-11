source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet-lint'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-puppet', '2.0.0'
  gem 'rspec', '2.14.1'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'pry'
  gem 'guard-rake'
end


if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 3.4.0'
end
