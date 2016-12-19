class Device < ActiveRecord::Base
  belongs_to :user
  enum user_agent: { ios: 0, android: 1 }
end
