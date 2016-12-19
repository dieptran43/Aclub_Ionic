require 'rails_helper'

describe AuthenticationToken do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:token) }
  end
end
