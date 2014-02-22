source 'https://rubygems.org'

group :development, :test do
  gem 'coveralls', require: false
  gem 'rake'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-system-puppet', '~> 2.0'
  gem 'puppet-lint', '~> 0.3.2'
  #gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git' , :ref => 'c44381a240ec420d4ffda7bffc55ee4d9c08d682'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
