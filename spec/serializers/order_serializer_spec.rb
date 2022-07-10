require 'rails_helper'

RSpec.describe OrderSerializer, type: :serializer do
  subject { described_class.render_as_hash(order) }

  let(:now) { DateTime.now }

  let(:from_currency) { create(:currency, name: 'Dollar', code: 'USD') }
  let(:to_currency) { create(:currency, name: 'Ruble', code: 'RUB') }
  let(:order) do
    create(
      :order, 
      from_currency: from_currency, 
      to_currency: to_currency,
      value: 10,
      expires_at: now + 15.minutes,
      completed_at: nil,
      complete_type: :take_profit,
      state: :created
    ) 
  end

  it do
    is_expected.to match(
      value: 10,
      complete_type: 'take_profit',
      completed_at: nil,
      state: 'created',
      from_currency: {code: 'USD', name: 'Dollar', id: from_currency.id},
      to_currency: {code: 'RUB', name: 'Ruble', id: to_currency.id},
      expires_at: now + 15.minutes,
      id: order.id
    )
  end
end
