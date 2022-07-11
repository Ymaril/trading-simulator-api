# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::ChargeService, type: :service do
  subject { described_class.perform(account, params, current_user) }

  let(:current_user) { create(:user) }
  let(:account) { create(:account, user: current_user, balance: 100) }

  let(:params) { ActionController::Parameters.new(value: value) }
  let(:value) { 5 }

  it do
    expect(subject.success?).to be_truthy
    expect(account.reload.balance).to eql(105)
  end

  describe 'not valid value' do
    let(:value) { -42 }

    it do
      expect(subject.success?).to be_falsy
      expect(account.reload.balance).to eql(100)
    end
  end
end
