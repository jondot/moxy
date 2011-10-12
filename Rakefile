$: << '.'
$: << File.expand_path('lib', File.dirname(__FILE__))

require 'rubygems'
require 'rake'
require 'rake/testtask'
require "bundler/gem_tasks"

require 'moxy'


Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end
