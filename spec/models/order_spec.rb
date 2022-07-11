# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  subject do
    described_class.new(
      from_currency: from_currency,
      to_currency: to_currency,
      user: user,
      value: value,
      complete_type: complete_type
    )
  end

  let(:user) { create(:user) }
  let(:from_currency) { create(:currency) }
  let(:to_currency) { create(:currency) }
  let(:value) { 4 }
  let(:complete_type) { 'take_profit' }

  it { is_expected.to be_valid }

  describe 'empty to_currency' do
    let(:to_currency) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'empty from_currency' do
    let(:from_currency) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'empty value' do
    let(:value) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'invalid value' do
    let(:value) { -42 }

    it { is_expected.to_not be_valid }
  end

  describe 'empty user' do
    let(:user) { nil }

    it { is_expected.to_not be_valid }
  end

  describe 'type stop_loss' do
    let(:complete_type) { 'stop_loss' }

    it { is_expected.to be_valid }
  end

  describe 'invalid type' do
    let(:complete_type) { 'take_loss' }

    it { expect { subject }.to raise_error ArgumentError }
  end

  describe 'state machine' do
    subject(:order) { create(:order, state: :created) }

    describe 'complete' do
      before { order.complete }

      it { is_expected.to be_completed }

      describe 'not allow to cancel' do
        before { order.cancel }

        it { is_expected.to be_completed }
      end
    end

    describe 'cancel' do
      before { order.cancel }

      it { is_expected.to be_canceled  }

      describe 'not allow to complete' do
        before { order.complete }

        it { is_expected.to be_canceled }
      end
    end
  end
end
