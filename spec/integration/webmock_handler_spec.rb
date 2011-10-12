require 'helper'



describe Moxy::WebMockHandler do
  before do
    set_app Moxy::WebMockHandler.new
    WebMock.reset!
  end

  it "should error 500 when no mock exists" do
    get '/'
    r.status.must_equal 500
    r.body.must_match "Unregistered request: GET http://example.org/ with headers"
  end

  it "should be able to set up a mock reply" do

    WebMock::API.stub_request(:get, "http://example.org/").to_return(:body => "hello moxy!")

    get '/'

    r.status.must_equal 200
    r.body.must_match "hello moxy!"
  end
end

