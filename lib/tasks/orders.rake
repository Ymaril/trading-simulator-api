# frozen_string_literal: true

namespace :orders do
  desc 'Performing orders'
  task perform: :environment do
    def current_value
      '(value * to_currencies.latest_rate / from_currencies.latest_rate)'
    end
    
    def orders
      Order.created
           .joins('LEFT JOIN currencies as from_currencies ON from_currencies.id = orders.from_currency_id')
           .joins('LEFT JOIN currencies as to_currencies ON to_currencies.id = orders.to_currency_id')
    end
    
    def to_complete_orders
      orders
        .where(<<-SQL)
          (#{current_value} > expected_value AND complete_type = 'take_profit') OR
          (#{current_value} < expected_value AND complete_type = 'stop_loss')
        SQL
    end
    
    def complete_order(order)
      from_account = order.user.accounts.find_by(currency: order.from_currency)
      to_account = order.user.accounts.find_or_create_by(currency: order.to_currency)
    
      if from_account.balance - order.value >= 0 && (order.expires_at.nil? || order.expires_at > DateTime.now)
        from_account.update(balance: from_account.balance - order.value)
        to_account.update(balance: to_account.balance + order.to_currency.latest_rate / order.from_currency.latest_rate * order.value)
    
        order.complete
      end
    end
    
    to_complete_orders.each(&method(:complete_order))
  end

  desc 'Cancel orders'
  task cancel: :environment do
    Order.created.where('expires_at < ?', DateTime.now).update_all(state: :canceled)
  end
end
