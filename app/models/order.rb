# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :from_currency, class_name: 'Currency'
  belongs_to :to_currency, class_name: 'Currency'

  validates :user, :from_currency, :to_currency, :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }

  enum complete_type: { take_profit: 'take_profit', stop_loss: 'stop_loss' }

  scope :created, -> { where(state: :created) }

  state_machine initial: :created do
    event :complete do
      transition created: :completed
    end

    event :cancel do
      transition created: :canceled
    end

    before_transition to: :completed do |order|
      order.completed_at = Time.current
    end
  end
end
