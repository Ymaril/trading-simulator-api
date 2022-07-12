# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'orders:perform', type: :task do
  after(:each) { Rake::Task['orders:perform'].reenable }

  let(:from_currency) { create(:currency, latest_rate: from_currency_rate) }
  let(:to_currency) { create(:currency, latest_rate: to_currency_rate) }

  let!(:from_account) { create(:account, user: user, currency: from_currency, balance: from_balance) }
  let!(:to_account) { create(:account, user: user, currency: to_currency, balance: to_balance) }

  let(:user) { create(:user) }

  let!(:order) do
    create(
      :order,
      user: user,
      value: value,
      expected_value: expected_value,
      from_currency: from_currency,
      to_currency: to_currency,
      complete_type: complete_type,
      state: state,
      expires_at: expires_at
    )
  end

  let(:from_currency_rate) { 1 }
  let(:to_currency_rate) { 2 }

  let(:from_balance) { 5 }
  let(:to_balance) { 0 }

  let(:value) { 5 }
  let(:expected_value) { 9 }

  let(:complete_type) { :take_profit }

  let(:state) { :created }
  let(:expires_at) { DateTime.now + 2.hour }

  describe 'simple' do
    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_completed
      expect(from_account.reload.balance).to eq(0)
      expect(to_account.reload.balance).to eq(10)
    end
  end

  describe 'not expected value' do
    let(:expected_value) { 11 }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_created
      expect(from_account.reload.balance).to eq(5)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'not expected rate' do
    let(:to_currency_rate) { 1.5 }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_created
      expect(from_account.reload.balance).to eq(5)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'not available balance' do
    let(:from_balance) { 4 }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_created
      expect(from_account.reload.balance).to eq(4)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'expired order' do
    let(:expires_at) { DateTime.now - 5.minutes }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_created
      expect(from_account.reload.balance).to eq(5)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'canceled' do
    let(:state) { :canceled }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_canceled
      expect(from_account.reload.balance).to eq(5)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'already completed' do
    let(:state) { :completed }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_completed
      expect(from_account.reload.balance).to eq(5)
      expect(to_account.reload.balance).to eq(0)
    end
  end

  describe 'stop_loss' do
    let(:from_currency_rate) { 1 }
    let(:to_currency_rate) { 2 }

    let(:from_balance) { 5 }
    let(:to_balance) { 0 }

    let(:value) { 5 }
    let(:expected_value) { 11 }

    let(:complete_type) { :stop_loss }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_completed
      expect(from_account.reload.balance).to eq(0)
      expect(to_account.reload.balance).to eq(10)
    end
  end

  describe 'some orders' do
    let(:from_currency2) { create(:currency, latest_rate: from_currency_rate2) }
    let(:to_currency2) { create(:currency, latest_rate: to_currency_rate2) }

    let!(:from_account2) { create(:account, user: user2, currency: from_currency2, balance: from_balance2) }
    let!(:to_account2) { create(:account, user: user2, currency: to_currency2, balance: to_balance2) }

    let(:user2) { create(:user) }

    let!(:order2) do
      create(
        :order,
        user: user2,
        value: value2,
        expected_value: expected_value2,
        from_currency: from_currency2,
        to_currency: to_currency2,
        complete_type: complete_type2,
        state: state2,
        expires_at: expires_at2
      )
    end

    let(:from_currency_rate2) { 1 }
    let(:to_currency_rate2) { 2 }

    let(:from_balance2) { 5 }
    let(:to_balance2) { 0 }

    let(:value2) { 5 }
    let(:expected_value2) { 11 }

    let(:complete_type2) { :stop_loss }

    let(:state2) { :created }
    let(:expires_at2) { DateTime.now + 2.hour }

    before { Rake::Task['orders:perform'].invoke }

    it do
      expect(order.reload).to be_completed
      expect(from_account.reload.balance).to eq(0)
      expect(to_account.reload.balance).to eq(10)

      expect(order2.reload).to be_completed
      expect(from_account2.reload.balance).to eq(0)
      expect(to_account2.reload.balance).to eq(10)
    end
  end
end
