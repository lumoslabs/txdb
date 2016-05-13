$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'txdb'

map '/hooks' do
  use Txdb::Hooks
  run Sinatra::Base
end

map '/triggers' do
  use Txdb::Triggers
  run Sinatra::Base
end
