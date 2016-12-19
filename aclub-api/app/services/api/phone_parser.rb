module Api
  class PhoneParser
    attr_accessor :phone
    attr_accessor :carrier_name

    VIETTLE = ['162', '163', '164', '165', '166', '167', '168', '169', '96', '97', '98']
    VIETTLE_CARRIER_NAME = 'viettle'
    OTHER_CARRIER_NAME = 'other'
   
    def initialize(phone)
      self.phone = self.class.normalize(phone)
      if VIETTLE.find{ |head| phone[2..-1].start_with?(head) }
        self.carrier_name = VIETTLE_CARRIER_NAME
      else
        self.carrier_name = OTHER_CARRIER_NAME
      end
    end
    
    def self.normalize(phone)
      new_phone = phone.gsub('-', '').gsub('+', '').gsub(' ', '')
      if new_phone.match /\A0(9|1)[0-9]{8,9}\z/
        new_phone = "84#{new_phone[1..-1]}"
      end
      new_phone
    end
  end
end
