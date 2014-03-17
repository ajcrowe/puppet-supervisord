source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-system-puppet', '~> 2.0'
  gem 'puppet-lint'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git' , :ref => 'c44381a240ec420d4ffda7bffc55ee4d9c08d682'
  #gem 'beaker-rspec', :require => false
  #gem 'pry'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
