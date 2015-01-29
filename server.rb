require 'sinatra'

set :public_folder, 'public'
set :bind, '0.0.0.0'

get "/" do
  "OK"
end

get '/cam' do
  "https://s3.amazonaws.com/cafeteria-picam/photo.jpg"
end

post '/cam' do
  channel = params[:channel_name]
  notifier = Slack::Notifier.new ENV["WEBHOOK_URL"], channel: channel, username: "Andycam"
  notifier.ping "<https://s3.amazonaws.com/cafeteria-picam/photo.jpg>"
  ""
end
