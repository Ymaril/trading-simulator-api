# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'orders:cancel', type: :task do
  after(:each) { Rake::Task['orders:cancel'].reenable }

  let!(:order) { create(:order, expires_at: expires_at, state: :created)}
  let(:expires_at) { DateTime.now - 5.minutes }

  describe 'cancel' do
    before { Rake::Task['orders:cancel'].invoke }

    it { expect(order.reload).to be_canceled }
  end

  describe 'not expired' do
    let(:expires_at) { DateTime.now + 5.minutes }

    before { Rake::Task['orders:cancel'].invoke }

    it { expect(order.reload).to be_created }
  end

  describe 'cancel some' do
    let!(:order2) { create(:order, expires_at: expires_at, state: :created)}

    before { Rake::Task['orders:cancel'].invoke }

    it do
      expect(order.reload).to be_canceled
      expect(order2.reload).to be_canceled
    end
  end
end
