# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountSerializer, type: :serializer do
  subject { described_class.render_as_hash(account) }

  let(:currency) { create(:currency, name: 'Dollar', code: 'USD') }
  let(:account) { create(:account, balance: 5, currency: currency) }

  it do
    is_expected.to match(
      balance: 5,
      currency: { code: 'USD', name: 'Dollar', id: currency.id },
      id: account.id
    )
  end
end
