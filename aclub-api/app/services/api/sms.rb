require 'uri'
require 'net/http'
require 'net/https'

module Api
  class SMS
    GETWAY_URL = "https://sgw01.cm.nl/gateway.ashx"

    def self.send_message(user)
      phone = Api::PhoneParser.new(user.phone)
      content_message = message(user.verification_token)
      if phone.carrier_name == Api::PhoneParser::VIETTLE_CARRIER_NAME
        send_viettle_message(user, content_message)
      else
        send_other_carrier_message(user, content_message)
      end
    end

    private
    def self.send_viettle_message(user, content_message)
      client = Savon.client(wsdl: "http://125.235.4.202:8985/WS?WSDL")
      client.call(:ws_cp_mt, message: {
                             'User' => 'bulk_bienbinh',
                             'Password' => Rails.application.secrets.viettel_bulk_sms_password,
                             'CPCode' => 'BIENBINH',
                             'ServiceID' => 'ACLUB',
                             'RequestID' => 4,
                             'CommandCode' => 'bulksms',
                             'UserID' => user.phone,
                             'ReceiverID' => user.phone,
                             'Content' => content_message,
                             'ContentType' => 'F'
                           })
    end

    def self.send_other_carrier_message(user, content_message)      
      # product_token = Rails.application.secrets.sms_production_token
      # body = content_message
      # to = user.phone
      # from = 'ACLUB'
      # data = "<MESSAGES><AUTHENTICATION><PRODUCTTOKEN><![CDATA[#{product_token}]]></PRODUCTTOKEN></AUTHENTICATION><MSG><FROM><![CDATA[#{from}]]></FROM><TO><![CDATA[#{to}]]></TO><BODY><![CDATA[#{body}]]></BODY></MSG></MESSAGES>"
      # uri = URI.parse(GETWAY_URL)
      # https = Net::HTTP.new(uri.host, uri.port)
      # https.use_ssl = true
      # request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/xml'})
      # request.body = data
      # https.request(request)
      UserMailer.send_email_verification_code(user.verification_token, user.email).deliver_now
    end

    def self.message(verification_token)
      "Ma xac nhan AClub cua ban la: #{verification_token}"
    end
  end
end