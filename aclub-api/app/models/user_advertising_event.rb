class UserAdvertisingEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :advertising_event

  validates :user, :advertising_event, presence: :true
  validates_uniqueness_of :user, scope: :advertising_event

  before_create :intialize_lucky_code

  def won?
    lucky_code.present?
  end

  private
  def intialize_lucky_code
    number_of_participants = advertising_event.users.count + 1
    number_of_winner = number_of_participants - advertising_event.user_advertising_events.where(lucky_code: nil).count - 1
    winning_rate = advertising_event.winning_rate.to_f
    if number_of_winner / (number_of_participants.to_f) < winning_rate && number_of_winner < advertising_event.maximum_number_of_winners.to_i
      generate_winner(winning_rate)
    end
  end

  def generate_winner(winning_rate)
    winner_number = (0..100).to_a.shuffle.first
    user_numbers = (0..winning_rate*100).to_a
    if user_numbers.include?(winner_number)
      self.lucky_code = loop do
        random_lucky_code = SecureRandom.hex(3)
        break random_lucky_code unless UserAdvertisingEvent.exists?(lucky_code: random_lucky_code)
      end
    end
  end
end
