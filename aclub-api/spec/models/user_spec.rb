require 'rails_helper'

RSpec.shared_examples "normalize_phone" do
  it "should convert phone number to 84972479830" do
    user.run_callbacks(:validation)
    expect(user.phone).to eq '84972479830'
  end
end

describe User do
  describe 'relationships' do
    it { is_expected.to have_one(:authentication_token).dependent(:destroy) }
    it { is_expected.to have_many(:user_coupons).dependent(:destroy) }
    it { is_expected.to have_many(:available_coupons).conditions(user_coupons: { status: 0 }).through(:user_coupons).source(:coupon) }
    it { is_expected.to have_many(:used_coupons).conditions(user_coupons: { status: 1 }).through(:user_coupons).source(:coupon) }
    it { is_expected.to have_many(:user_advertising_events).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to allow_value('84969032266').for(:phone) }
    it { is_expected.to allow_value('841690322666').for(:phone) }
    it { is_expected.to_not allow_value('831690322666').for(:phone) }
    it { is_expected.to_not allow_value('842690322666').for(:phone) }
    it { is_expected.to validate_uniqueness_of(:phone) }
  end

  describe "callbacks" do
    let(:user) { build(:user) }

    context ".after_create" do
      after do
        user.save
      end

      it "send verification code to user" do
        expect(user).to receive(:send_verification_code)
      end
    end

    describe "before_validation .normalize_phone" do
      context "phone format: '+84 972479830'" do
        let(:phone) { '+84 972479830' }
        let(:user) { build(:user, phone: phone) }

        it_behaves_like "normalize_phone"
      end

      context "phone format: '8497 247 98 30'" do
        let(:phone) { '8497 247 98 30' }
        let(:user) { build(:user, phone: phone) }

        it_behaves_like "normalize_phone"
      end

      context "phone format: '0972479830'" do
        let(:phone) { '0972479830' }
        let(:user) { build(:user, phone: phone) }

        it_behaves_like "normalize_phone"
      end

      context "phone format: '0972-479-830'" do
        let(:phone) { '0972-479-830' }
        let(:user) { build(:user, phone: phone) }

        it_behaves_like "normalize_phone"
      end
    end
  end

  describe 'validation #required_name?' do
    context 'newly created record' do
      let(:user_1) { build(:user, name: '') }
      let(:user_2) { build(:user, name: nil) }

      it 'should allow name to be blank' do
        expect(user_1.save).to eq true
        user_1.destroy
        expect(user_2.save).to eq true
      end
    end

    context 'updating record' do
      context 'update name to nil or empty' do
        let(:user) { create(:user, name: Faker::Internet.name) }

        it 'should not allow name to be updated' do
          user.name = nil
          expect(user.save).to eq false
          user.name = ''
          expect(user.save).to eq false
        end
      end

      context 'update name to non empty' do
        let(:new_name) { Faker::Internet.name }
        let(:user) { create(:user, name: Faker::Internet.name) }

        it 'should allow name to be updated' do
          user.name = new_name
          expect(user.save).to eq true
          expect(user.name).to eq new_name
        end
      end
    end
  end

  describe 'validation #unregistered_email' do
    context 'there is an user has registered the email already' do
      let(:email) { Faker::Internet.email }
      let!(:old_user) { create(:user, email: email) }
      let(:new_user) { create(:user, phone: '84972479830') }

      it "should not allow new user to register old user's email as unverified email" do
        expect(new_user.update_attributes(unverified_email: email)).to eq false
      end
    end

    context 'the email is available' do
      let(:email) { Faker::Internet.email }
      let(:new_user) { create(:user) }

      it "should allow new user to register the email as unverified email" do
        expect(new_user.update_attributes(unverified_email: email)).to eq true
      end
    end
  end

  describe 'validation #not_allow_to_update_phone' do
    context 'the user has phone already' do
      let(:user) { create(:user, phone: '0972479830') }

      it "should not allow user to update phone" do
        expect(user.update_attributes(phone: '0972479831')).to eq false
      end
    end

    context 'the user does not phone' do
      let(:user) { build(:user, phone: nil) }

      it "should allow user to update phone" do
        user.save(validate: false)
        expect(user.update_attributes(phone: '0972479831')).to eq true
      end
    end
  end

  describe 'scope .newest' do
    let!(:newest_users_1) { create(:user, created_at: 2.days.ago) }
    let!(:newest_users_2) { create(:user, created_at: 1.days.ago) }

    it 'returns newest user' do
      expect(User.newest.pluck(:id)).to eq [newest_users_2, newest_users_1].map(&:id)
    end
  end

  describe 'scope .most_active' do
    let!(:newest_users_1) { create(:user, created_at: 2.days.ago) }
    let!(:newest_users_2) { create(:user, created_at: 1.days.ago) }

    it 'returns most_active user' do
      expect(User.most_active.pluck(:id)).to eq [newest_users_2, newest_users_1].map(&:id)
    end
  end
end
