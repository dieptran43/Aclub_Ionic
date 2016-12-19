require 'rails_helper'

module Api
  RSpec.describe NotificationService do
    let(:android_devices) { create_list(:device, 3, user_agent: 'android') }
    let(:apple_devices) { create_list(:device, 3, user_agent: 'ios') }
    let(:devices) { Device.where(id: (android_devices + apple_devices).map(&:id)) }
    let(:message) { Faker::Lorem.paragraph }
    let(:notification_service) { NotificationService.new(devices, message) }
    let(:apple_app) { double(Apns) }
    let(:android_app) { double(RailsPushNotifications::GCMApp) }

    before do
      allow(Apns).to receive(:instance).and_return(apple_app)
      allow(RailsPushNotifications::GCMApp).to receive(:find_or_create_by).and_return(android_app)
    end

    describe '#initialize' do
      it 'should create notification service instance' do
        expect(notification_service.devices).to eq devices
        expect(notification_service.message).to eq message
        expect(notification_service.apple_app).to eq apple_app
        expect(notification_service.android_app).to eq android_app
      end
    end

    describe '#push_notification' do
      let(:data) { { "faker" => "faker" } }
      let(:expected_android_params) { { destinations: android_devices.map(&:token), data: { text: message, information: data } } }

      it 'should push notification to all devices' do
        apple_devices.each do |device|
          expect(apple_app).to receive(:push).with(device.token, message, data)
        end
        expect(android_app).to receive_message_chain(:notifications, :create).with(expected_android_params)
        expect(android_app).to receive(:push_notifications)
        notification_service.push_notification(data)
      end
    end
  end
end