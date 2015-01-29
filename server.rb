require 'sinatra'

set :public_folder, 'public'
set :bind, '0.0.0.0'

$TAKING_PHOTO = false

get "/" do
  "OK"
end

def take_photo
  last_taken = File.ctime("public/photo.jpg")
  delta = Time.now - last_taken
  puts "Time since last photo: #{delta.to_i} seconds"
  if delta > 15 && !$TAKING_PHOTO
    puts "Taking new photo"
    $TAKING_PHOTO = true
    `raspistill -o public/photo.jpg -w 800 -h 600`
    $TAKING_PHOTO = false
  end
end

get '/cam' do
  take_photo
  send_file File.join("public/photo.jpg")
end

post '/cam' do
  take_photo
  "http://#{request.host_with_port}/photo.jpg"
end
