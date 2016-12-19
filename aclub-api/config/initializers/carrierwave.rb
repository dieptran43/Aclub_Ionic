require "carrierwave/orm/activerecord"

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region: 'ap-southeast-1'
  }
  config.fog_directory  = "aclub-production"
  #config.fog_directory  = "aclub-development"
end
