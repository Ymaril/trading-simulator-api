require 'rails_helper'

RSpec.describe CurrenciesFetcher, type: :fetcher do
  let(:fetcher) { described_class.new Currency.all }

  subject { fetcher.build(params) }
  let(:meta) { fetcher.meta }

  describe 'filters' do
    describe 'name' do
      describe 'equal' do
        let(:params) { {'name' => 'Dollar'} }

        before do
          create(:currency, name: 'Dollar')
          create(:currency, name: 'Ruble')
          create(:currency, name: 'Lari')
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe 'code' do
      describe 'equal' do
        let(:params) { {'code' => 'USD'} }

        before do
          create(:currency, code: 'USD')
          create(:currency, code: 'BTC')
          create(:currency, code: 'RUB')
        end

        it { expect(subject.count).to eq(1) }
      end
    end
  end

  describe 'sorting' do
    let(:params) { {'sort_by' => sort_by, 'order_by' => order_by} }

    describe 'name' do
      let(:sort_by) { 'name' }

      before do
        create(:currency, name: 'Bitcoin')
        create(:currency, name: 'Australian Dollar')
        create(:currency, name: 'Conda')
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:name)).to eql(['Australian Dollar', 'Bitcoin', 'Conda'])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:name)).to eql(['Conda', 'Bitcoin', 'Australian Dollar'])
        end
      end
    end

    describe 'code' do
      let(:sort_by) { 'code' }

      before do
        create(:currency, code: 'BTC')
        create(:currency, code: 'AUS')
        create(:currency, code: 'CSA')
      end

      describe 'asc' do
        let(:order_by) { 'ASC' }

        it do
          expect(subject.pluck(:code)).to eql(['AUS', 'BTC', 'CSA'])
        end
      end

      describe 'desc' do
        let(:order_by) { 'DESC' }

        it do
          expect(subject.pluck(:code)).to eql(['CSA', 'BTC', 'AUS'])
        end
      end
    end
  end

  describe 'pagination' do
    let(:params) { {per_page: 5, page: page} }

    before do
      create_list(:currency, 7)
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
