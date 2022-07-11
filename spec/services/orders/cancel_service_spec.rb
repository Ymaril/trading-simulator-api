# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Orders::CancelService, type: :service do
  subject { described_class.perform(order, current_user) }

  let(:current_user) { create(:user) }
  let(:order) { create(:order, user: current_user, state: :created) }

  it do
    expect(subject.success?).to be_truthy
    expect(order.reload).to be_canceled
  end
end
