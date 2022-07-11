# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalApi::ExchangeRatesService, type: :service do
  before do
    VCR.insert_cassette 'exchange_rates', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'get_rates' do
    subject { described_class.get_rates(currency_codes) }

    let(:currency_codes) { ['USD'] }

    it { is_expected.to include('USD' => 1) }

    describe 'some' do
      let(:currency_codes) { %w[USD BTC] }

      it do
        expect(subject.keys).to include('USD', 'BTC')
        is_expected.to include('USD' => 1)
      end
    end
  end
end
