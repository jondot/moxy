require 'httparty'
require 'minitest/autorun'

class Google
  include HTTParty
  format :html
end

# globally set to our moxie instance.
Google.http_proxy 'localhost', 9292


describe Google do
  it "should handle google crashes" do
    # setup responses at moxie.
    HTTParty.post('http://localhost:9292/__setup__', 
                  :body=>{
                    :mock_text=>'stub_request(:get, "http://google.com?q=moxie").to_return(:status=>401)'
                  })

    r = Google.get("http://google.com?q=moxie")

    # betcha didn't expect that one from google Search!
    r.code.must_equal 401
  end
end


