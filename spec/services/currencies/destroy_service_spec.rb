# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currencies::DestroyService, type: :service do
  subject { described_class.perform(currency) }

  let!(:currency) { create(:currency) }

  it do
    expect(subject.success?).to be_truthy
    expect(Currency.where(code: 'USD', name: 'Dollar')).to_not exist
  end

  describe 'in use' do
    before { create(:account, currency: currency) }

    it do
      expect(subject.success?).to be_falsy
      expect(currency.reload).to be_present
    end
  end
end
