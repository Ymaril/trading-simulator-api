require 'rails_helper'

RSpec.describe Currency, type: :model do
  subject { described_class.new(code: code, name: name) }

  let(:code) { 'USD' }
  let(:name) { 'Dollar' }

  it { expect(subject).to be_valid }

  describe 'empty name' do
    let(:name) { '' }

    it { expect(subject).to_not be_valid }
  end

  describe 'empty code' do
    let(:code) { '' }

    it { expect(subject).to_not be_valid }
  end

  describe 'not uniq code' do
    before do
      create(:currency, code: 'RUB')
    end

    let(:code) { 'RUB' }

    it { expect(subject).to_not be_valid }
  end
end
