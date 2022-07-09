class Order < ApplicationRecord
  belongs_to :user
  belongs_to :from_currency, class_name: 'Currency'
  belongs_to :to_currency, class_name: 'Currency'

  validates :user, :from_currency, :to_currency, :value,  presence: true
  validates :value, numericality: {greater_than_or_equal_to: 0}

  enum complete_type: %w[take_profit stop_loss]
  
  state_machine initial: :created do
    event :complete do
      transition :created => :completed
    end

    event :cancel do
      transition :created => :canceled
    end
  end
end
