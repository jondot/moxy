require 'helper'



describe Moxy::App do
  before do
    set_app Moxy::App
    WebMock.reset!
  end

  it "should set up a mock" do
    script=<<-EOF
      stub_request(:get, "http://example.org").to_return(:body=>"hello")
    EOF

    post '/', {:mock_text=>script}

    WebMock::StubRegistry.instance.request_stubs.size.must_equal 1
    WebMock::StubRegistry.instance.request_stubs.first.response.body.must_equal "hello"
  end
end

