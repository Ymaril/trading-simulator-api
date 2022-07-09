require 'rails_helper'

RSpec.describe Orders::CreateService, type: :service do
  subject { described_class.perform(params, current_user) }

  let(:now) { DateTime.now }

  let(:current_user) { create(:user) }
  let(:from_currency) { create(:currency) }
  let(:to_currency) { create(:currency) }
  let(:value) { 10 }
  let(:expires_at) { now + 2.months }
  let(:complete_type) { 'take_profit' }

  let(:params) do 
    ActionController::Parameters.new(
      from_currency_id: from_currency.id, 
      to_currency_id: to_currency.id, 
      value: value,
      expires_at: expires_at,
      complete_type: complete_type
    )
  end

  describe 'successful' do
    before do
      create(:account, currency: from_currency, user: current_user)
    end

    it do
      expect(subject.success?).to be_truthy
      expect(Order.where(user: current_user, from_currency: from_currency, value: value)).to exist
    end
  end

  describe 'current_user not have account' do
    let(:current_user) { create(:user) }

    it do
      expect(subject.success?).to be_falsy
      expect(Order.where(user: current_user, from_currency: from_currency, value: value)).to_not exist
    end
  end
end
