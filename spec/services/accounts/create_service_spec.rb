# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::CreateService, type: :service do
  subject { described_class.perform(params, current_user) }

  let(:current_user) { create(:user) }
  let(:currency) { create(:currency) }

  let(:params) { ActionController::Parameters.new(currency_id: currency.id) }

  it do
    expect(subject.success?).to be_truthy
    expect(Account.where(user: current_user, currency: currency)).to exist
  end

  describe 'current_user not exist' do
    let(:current_user) { nil }

    it do
      expect(subject.success?).to be_falsy
      expect(Account.where(user: current_user, currency: currency)).to_not exist
    end
  end

  describe 'not uniq account' do
    before { create(:account, user: current_user, currency: currency) }

    it do
      expect(subject.success?).to be_falsy
      expect(Account.where(user: current_user, currency: currency).count).to eq(1)
    end
  end
end
