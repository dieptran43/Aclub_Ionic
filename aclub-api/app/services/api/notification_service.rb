module Api
  class NotificationService
    attr_accessor :android_app, :apple_app, :devices, :message

    def initialize(devices, message)
      self.devices = devices
      self.message = message
      self.apple_app = Apns.instance
      self.android_app = RailsPushNotifications::GCMApp.find_or_create_by(gcm_key: Rails.application.secrets.google_api_key)
    end

    def push_notification(data = {})
      devices.ios.each do |device|
        apple_app.push(device.token, message, data)
      end
      unless devices.android.empty?
        android_app.notifications.create(destinations: devices.android.map(&:token), data: { text: message, information: data })
        android_app.push_notifications
      end
    end
  end
end