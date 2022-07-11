# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currencies::CreateService, type: :service do
  subject { described_class.perform(params) }

  let(:params) { ActionController::Parameters.new(code: 'USD', name: 'Dollar') }

  it do
    expect(subject.success?).to be_truthy
    expect(Currency.where(code: 'USD', name: 'Dollar')).to exist
  end
end
