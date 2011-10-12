require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

require 'minitest/autorun'
require 'webmock/minitest'

require 'rack/test'

require 'rr'
require 'moxy'

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end

class MiniTest::Spec
  include Rack::Test::Methods
  
  def set_app(app)
    @app = app
  end

  def app
    @app
  end

  def r
    last_response
  end
end



def file_content(file)
  File.read(File.expand_path("files/"+file, File.dirname(__FILE__)))
end




# Project.log = Logger.new('/dev/null')
