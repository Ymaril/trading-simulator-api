# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { described_class.new(user: user, currency: currency, balance: balance) }

  let(:user) { create(:user) }
  let(:currency) { create(:currency) }
  let(:balance) { 0 }

  it { is_expected.to be_valid }

  describe 'empty user' do
    let(:user) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'empty currency' do
    let(:currency) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'not uniq account' do
    before { create(:account, user: user, currency: currency) }

    it { is_expected.to_not be_valid }
  end
end
