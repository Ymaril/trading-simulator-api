require 'rails_helper'

RSpec.describe AccountsFetcher, type: :fetcher do
  let(:fetcher) { described_class.new Account.all }

  subject { fetcher.build(params) }
  let(:meta) { fetcher.meta }

  describe 'filters' do
    describe 'balance' do
      before do
        create(:account, balance: 0)
        create(:account, balance: 4)
        create(:account, balance: 5)
      end

      describe 'equal' do
        let(:params) { {'balance' => 4} }

        it { expect(subject.count).to eq(1) }
      end
      describe 'greater' do
        let(:params) { {'balance' => {'gte' => 3}} }

        it { expect(subject.count).to eq(2) }
      end
      describe 'lower' do
        let(:params) { {'balance' => {'lte' => 3}} }

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'user_id' do
      let(:user) { create(:user) }

      before do
        create(:account, user_id: user.id)
        create(:account)
        create(:account)
      end

      describe 'equal' do
        let(:params) { {'user_id' => user.id} }

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'currency_id' do
      let(:currency) { create(:currency) }

      before do
        create(:account, currency_id: currency.id)
        create(:account)
        create(:account)
      end

      describe 'equal' do
        let(:params) { {'currency_id' => currency.id} }

        it { expect(subject.count).to eq(1) }
      end
    end
  end

  describe 'sorting' do
    let(:params) { {'sort_by' => sort_by, 'order_by' => order_by} }

    describe 'balance' do
      let(:sort_by) { 'balance' }

      before do
        create(:account, balance: 4)
        create(:account, balance: 2)
        create(:account, balance: 3)
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:balance)).to eql([2, 3, 4])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:balance)).to eql([4, 3, 2])
        end
      end
    end
  end

  describe 'pagination' do
    let(:params) { {per_page: 5, page: page} }

    before do
      create_list(:account, 7)
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
