# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rdoc/task'

require 'rspec/core'
require 'rspec/core/rake_task'

# Clear tmp folder
require "fileutils"
FileUtils.rm_r "#{File.dirname(__FILE__)}/spec/tmp", :force => true 

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--options', "spec/spec.opts"]
end

task :default => :spec

desc 'Generate documentation for the sunrise plugin.'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Sunrise Core'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
