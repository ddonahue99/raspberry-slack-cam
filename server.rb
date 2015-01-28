require 'sinatra'

get "/" do
  "OK"
end

post '/cam' do
  send_file File.join("test.jpg")
end
