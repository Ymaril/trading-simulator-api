# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersFetcher, type: :fetcher do
  let(:fetcher) { described_class.new Order.all }

  subject { fetcher.build(params) }
  let(:meta) { fetcher.meta }

  describe 'filters' do
    describe 'from_currency' do
      describe 'equal' do
        let!(:from_currency) { create(:currency) }
        let(:params) { { 'from_currency_id' => from_currency.id } }

        before do
          create(:order, from_currency: from_currency)
          create_list(:order, 2)
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'to_currency' do
      describe 'equal' do
        let!(:to_currency) { create(:currency) }
        let(:params) { { 'to_currency_id' => to_currency.id } }

        before do
          create(:order, to_currency: to_currency)
          create_list(:order, 2)
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'user' do
      describe 'equal' do
        let!(:user) { create(:user) }
        let(:params) { { 'user_id' => user.id } }

        before do
          create(:order, user: user)
          create_list(:order, 2)
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'value' do
      before do
        create(:order, value: 0)
        create(:order, value: 4)
        create(:order, value: 5)
      end

      describe 'equal' do
        let(:params) { { 'value' => 4 } }

        it { expect(subject.count).to eq(1) }
      end
      describe 'greater' do
        let(:params) { { 'value' => { 'gte' => 3 } } }

        it { expect(subject.count).to eq(2) }
      end
      describe 'lower' do
        let(:params) { { 'value' => { 'lte' => 3 } } }

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'expires_at' do
      let(:now) { DateTime.now }

      before do
        create(:order, expires_at: now + 5.minutes)
        create(:order, expires_at: now + 10.minutes)
        create(:order, expires_at: now + 20.minutes)
      end

      describe 'equal' do
        let(:params) { { 'expires_at' => now + 10.minutes } }

        it { expect(subject.count).to eq(1) }
      end
      describe 'greater' do
        let(:params) { { 'expires_at' => { 'gte' => now + 7.minutes } } }

        it { expect(subject.count).to eq(2) }
      end
      describe 'lower' do
        let(:params) { { 'expires_at' => { 'lte' => now + 7.minutes } } }

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'completed_at' do
      let(:now) { DateTime.now }

      before do
        create(:order, completed_at: now + 5.minutes)
        create(:order, completed_at: now + 10.minutes)
        create(:order, completed_at: now + 20.minutes)
      end

      describe 'equal' do
        let(:params) { { 'completed_at' => now + 10.minutes } }

        it { expect(subject.count).to eq(1) }
      end
      describe 'greater' do
        let(:params) { { 'completed_at' => { 'gte' => now + 7.minutes } } }

        it { expect(subject.count).to eq(2) }
      end
      describe 'lower' do
        let(:params) { { 'completed_at' => { 'lte' => now + 7.minutes } } }

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'state' do
      describe 'equal' do
        let(:params) { { 'state' => 'canceled' } }

        before do
          create(:order, state: :created)
          create(:order, state: :canceled)
          create(:order, state: :completed)
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'complete_type' do
      describe 'equal' do
        let(:params) { { 'complete_type' => 'take_profit' } }

        before do
          create(:order, complete_type: 'stop_loss')
          create(:order, complete_type: 'take_profit')
          create(:order, complete_type: 'stop_loss')
        end

        it { expect(subject.count).to eq(1) }
      end
    end
  end

  describe 'sorting' do
    let(:params) { { 'sort_by' => sort_by, 'order_by' => order_by } }

    describe 'value' do
      let(:sort_by) { 'value' }

      before do
        create(:order, value: 2)
        create(:order, value: 5)
        create(:order, value: 3)
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:value)).to eql([2, 3, 5])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:value)).to eql([5, 3, 2])
        end
      end
    end

    describe 'expires_at' do
      let(:sort_by) { 'expires_at' }

      let(:now) { DateTime.now }

      before do
        create(:order, expires_at: now + 10.minutes, value: 2)
        create(:order, expires_at: now + 5.minutes, value: 1)
        create(:order, expires_at: now + 20.minutes, value: 3)
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:value)).to eql([1, 2, 3])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:value)).to eql([3, 2, 1])
        end
      end
    end

    describe 'completed_at' do
      let(:sort_by) { 'completed_at' }

      let(:now) { DateTime.now }

      before do
        create(:order, completed_at: now + 10.minutes, value: 2)
        create(:order, completed_at: now + 5.minutes, value: 1)
        create(:order, completed_at: now + 20.minutes, value: 3)
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:value)).to eql([1, 2, 3])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:value)).to eql([3, 2, 1])
        end
      end
    end
  end

  describe 'pagination' do
    let(:params) { { per_page: 5, page: page } }

    before do
      create_list(:order, 7)
    end

    describe 'first page' do
      let(:page) { 1 }

      it do
        expect(subject.count).to eq(5)
        expect(meta).to include(
          current_page: 1,
          total_pages: 2,
          per_page: 5,
          total_count: 7
        )
      end
    end

    describe 'second page' do
      let(:page) { 2 }

      it do
        expect(subject.count).to eq(2)
        expect(meta).to include(
          current_page: 2,
          total_pages: 2,
          per_page: 5,
          total_count: 7
        )
      end
    end
  end
end
