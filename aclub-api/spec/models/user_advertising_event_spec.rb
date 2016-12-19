require 'rails_helper'

RSpec.describe UserAdvertisingEvent, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:advertising_event) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:advertising_event) }
  end

  describe 'before_create callback #intialize_lucky_code' do
    let(:advertising_event) { build(:advertising_event, winning_rate: winning_rate) }
    let(:user_advertising_event) { build(:user_advertising_event, advertising_event: advertising_event) }

    context 'ratio between number of winners and participants is smaller than default ration setting by admin' do
      let(:winning_rate) { 1.0 }

      it 'should run generate_winner' do
        expect(user_advertising_event).to receive(:generate_winner).with(advertising_event.winning_rate)
        user_advertising_event.run_callbacks(:create)
      end
    end

    context 'ratio between number of winners and participants is not smaller than default ration setting by admin' do
      let(:winning_rate) { 0.0 }

      it 'should not run generate_winner' do
        expect(user_advertising_event).not_to receive(:generate_winner)
        user_advertising_event.run_callbacks(:create)
      end
    end
  end

  describe 'private method generate_winner' do
    let(:winning_rate) { 0.5 }
    let(:advertising_event) { create(:advertising_event, winning_rate: winning_rate) }
    let!(:user_advertising_event) { create(:user_advertising_event, advertising_event: advertising_event) }

    it 'should randomly decide where user win or do not win event' do
      user_advertising_event.update_attributes(lucky_code: nil)
      allow_any_instance_of(Array).to receive_message_chain(:shuffle, :first).and_return(51)
      user_advertising_event.send(:generate_winner, winning_rate)
      expect(user_advertising_event.lucky_code).to be_blank

      allow_any_instance_of(Array).to receive_message_chain(:shuffle, :first).and_return(49)
      user_advertising_event.send(:generate_winner, winning_rate)
      expect(user_advertising_event.lucky_code).to be_present
    end
  end
end
