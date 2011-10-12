$: << '.'
$: << 'lib'

require 'moxy'
require 'moxy/app'


map "/" do
  run Moxy::WebMockHandler.new
end

map "/__setup__" do
  run Moxy::App
end



