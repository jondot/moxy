require 'sinatra'
require 'sinatra/flash'
require 'moxy/sandbox_eval'


module Moxy
  class App < Sinatra::Base
    filedir = File.dirname(__FILE__)
    set :public_folder, File.expand_path("../../public", filedir)
    set :views, File.expand_path("../../views", filedir)
    enable :sessions
    use Sinatra::Flash


    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      def current_section
        url_path request.path_info.sub('/','').split('/')[0].downcase
      end

      def current_page
        url_path request.path_info.sub('/','')
      end

      def url_path(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end
      alias_method :u, :url_path

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    get '/reset' do
      WebMock.reset!
      redirect path_prefix
    end

    get '/current' do
      @reqs = WebMock::StubRegistry.instance.request_stubs.each { |r| r.to_s } || []
      erb :current
    end

    get '/' do
      @numreqs = WebMock::StubRegistry.instance.request_stubs.size
      erb :editor
    end

    post '/' do
      flag, res = SandboxEval.new(development?).evaluate(params[:mock_text]) if params[:mock_text]
      
      if(flag == :ok)
        flash[:notice] = "Your request #{res} have been registered."
      elsif
        flash[:error]  = "Error registering this request: #{res}"
        headers 'x-moxy-errors' => "#{flag}: #{res}"
      end
      redirect path_prefix
    end
  end
end


