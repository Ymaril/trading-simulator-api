# frozen_string_literal: true

require 'rails_helper'

Rails.application.load_tasks

RSpec.describe 'currencies:update_rates', type: :serializer do
  let!(:currency1) { create(:currency, code: 'USD', latest_rate: nil) }
  let!(:currency2) { create(:currency, code: 'BTC', latest_rate: nil) }
  let!(:currency3) { create(:currency, code: 'AMD', latest_rate: nil) }

  before do
    allow(ExternalApi::ExchangeRatesService).to receive(:get_rates).and_return(
      { 'USD' => 1, 'BTC' => 0.422, 'AMD' => 0.00012 }
    )

    Rake::Task["currencies:update_rates"].invoke
  end

  it do
    expect(currency1.reload.latest_rate).to eq(1)
    expect(currency2.reload.latest_rate).to eq(0.422)
    expect(currency3.reload.latest_rate).to eq(0.00012)
  end
end