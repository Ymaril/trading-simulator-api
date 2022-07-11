# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencySerializer, type: :serializer do
  subject { described_class.render_as_hash(currency) }

  let(:currency) { create(:currency, name: 'Dollar', code: 'USD') }

  it do
    is_expected.to match(
      name: 'Dollar',
      code: 'USD',
      id: currency.id
    )
  end
end
