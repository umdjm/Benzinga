class StockResult < ActiveRecord::Base
  attr_accessible :result_date, :stock, :closing_price, :current_price

  has_many :stock_picks

  def market_open
    return true if self.closing_price.nil?
    return false
  end

  def price
    return market_open ? self.current_price : self.closing_price
  end


  def self.update_prices
    StockResult.where(:closing_price => nil).each do |result|
      quote = StockQuote::Stock.quote(result.stock)
      if quote.response_code == 200
        result.current_price = quote.ask
        result.closing_price = quote.previous_close if Date.strptime(quote.last_trade_date, "%m/%d/%Y") >= result.result_date
        result.save
      end
    end
  end

end
