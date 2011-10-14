require 'helper'



describe Moxy::App do
  SCRIPT=<<-EOF
    stub_request(:get, "http://example.org").to_return(:body=>"hello")
  EOF

  before do
    set_app Moxy::App
    WebMock.reset!
  end

  it "should set up a mock" do
    post '/', {:mock_text=>SCRIPT}
    WebMock::StubRegistry.instance.request_stubs.size.must_equal 1
    WebMock::StubRegistry.instance.request_stubs.first.response.body.must_equal "hello"
  end

  it "should reset mocks" do
    post '/', {:mock_text => SCRIPT}
    get  '/reset'
    WebMock::StubRegistry.instance.request_stubs.size.must_equal 0
  end

  it "should list out all existing mocks" do
    post '/', {:mock_text => SCRIPT}
    get  '/current'
    r.body.must_match "GET http://example.org"
  end

  it "should indicate error" do
    post '/', {:mock_text => "foobar"}
    get  '/'
    r.body.must_match "Error registering this request: undefined local variable or method"
  end
end


