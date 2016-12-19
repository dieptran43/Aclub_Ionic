require 'singleton'

class Apns
  include Singleton

  def initialize
    if Rails.env.production?
      @APN = Houston::Client.production
    else
      @APN = Houston::Client.development
    end
    @APN.certificate = File.read(Rails.application.secrets.apns_certificate)
    @APN.passphrase = Rails.application.secrets.apns_passphrase
  end

  def push(token, alert, data = {})
    notification = Houston::Notification.new(device: token)
    notification.alert = alert
    notification.badge = 1
    notification.sound = 'sosumi.aiff'
    notification.custom_data = data
    @APN.push(notification)
  end
end
