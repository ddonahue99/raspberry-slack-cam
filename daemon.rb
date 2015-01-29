require 'aws-sdk'

class PhotoDaemon
  attr_accessor :config_file

  def initialize(config_file)
    @config_file = config_file
  end

  def s3_config
    @_s3_config ||= YAML.load_file(config_file)['s3']
  end
 
  def s3
    @_s3 ||= AWS::S3.new(s3_config)
  end
  
  def upload_file
    file_name = File.expand_path("../public/photo.jpg", __FILE__)
    key = File.basename(file_name)
    s3.buckets[s3_config['bucket_name']].objects[key].write(:file => file_name)
  end

  def run!
    while(true) do
      puts "Taking picture"
      `raspistill -o #{File.expand_path('../public/photo.jpg', __FILE__)} -w 800 -h 600`
      puts "Uploading to S3"
      upload_file
      puts "Taking a nap.."
      sleep 5
    end
  end
end

PhotoDaemon.new(File.expand_path("../config.yml", __FILE__)).run!
