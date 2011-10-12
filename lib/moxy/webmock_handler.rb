

module Moxy
  class WebMockHandler
    def self.build_request_signature(req)
      # mostly taking building request and response based on the patron
      # (and others) adapter: https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_adapters/patron_adapter.rb
      uri = WebMock::Util::URI.heuristic_parse(req.url)
      uri.path = uri.normalized_path.gsub("[^:]//","/")

#todo: authorization, see #https://github.com/bblimke/webmock/blob/master/lib/webmock/http_lib_adapters/net_http.rb

      client_headers = {}
      req.env.keys.grep(/^HTTP_/).each do |k|
        client_headers[k[5..-1]] = req.env[k]   #remove client headers prefix 'http_'
      end
#client_headers['content-type'] = req.env['CONTENT_TYPE']
#client_headers['content-length'] = req.env['CONTENT_LENGTH']

#puts "client headers\n----------\n#{client_headers.inspect}\n---------"

      request_signature = WebMock::RequestSignature.new(
        req.request_method.downcase.to_sym,
        uri.to_s,
        :body => req.body.read,
        :headers => client_headers
      )
      request_signature
    end

    def self.build_rack_response(webmock_response)
      webmock_response.raise_error_if_any
      [webmock_response.status[0], webmock_response.headers || {}, bodify(webmock_response.body)]
    end

    def self.bodify(body)
      body.respond_to?(:each) ? body : [body]
    end

    def call(env)
      req = Rack::Request.new(env)

      request_signature = Moxy::WebMockHandler.build_request_signature(req)

#puts 'req signature----'
#puts request_signature.inspect
#puts '--------'

      WebMock::RequestRegistry.instance.requested_signatures.put(request_signature)

      begin
        if WebMock::StubRegistry.instance.registered_request?(request_signature)
          webmock_response = WebMock::StubRegistry.instance.response_for_request(request_signature)
# todo - originally 'handle file name' in patron. why?
# WebMock::HttpLibAdapters::PatronAdapter.handle_file_name(req, webmock_response)
          res = Moxy::WebMockHandler.build_rack_response(webmock_response)
          WebMock::CallbackRegistry.invoke_callbacks({:lib => :patron}, request_signature, webmock_response)
        elsif WebMock.net_connect_allowed?(request_signature.uri)
          res = handle_request_without_webmock(req)
          if WebMock::CallbackRegistry.any_callbacks?
            webmock_response = WebMock::HttpLibAdapters::PatronAdapter.
            build_webmock_response(res)
            WebMock::CallbackRegistry.invoke_callbacks({:lib => :patron, :real_request => true}, request_signature, webmock_response)
          end
        else
          raise WebMock::NetConnectNotAllowedError.new(request_signature)
        end




        res[1]['content-type'] ||= 'text/html' #passing rack-lint, see http://rack.rubyforge.org/doc/SPEC.html
#todo - what about content-length when it doesn't come from
#webmock? does it get calculated automatically be webmock?

#puts "final-------------------\n#{res.inspect}\n-------------"

        return res

      rescue WebMock::NetConnectNotAllowedError => ex
        return [500, 
                {"content-type" => "text/plain", 
                 "content-length" => ex.message.length.to_s},
                Moxy::WebMockHandler.bodify(ex.message.to_s)]
      end
    end
  end
end
