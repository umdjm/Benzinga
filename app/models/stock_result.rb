class StockResult < ActiveRecord::Base
  attr_accessible :result_date, :stock, :closing_price

  has_many :stock_picks

  def market_open
    return true if self.closing_price.nil?
    return false
  end

  def price
    if market_open
      quote = StockQuote::Stock.quote(self.stock)
      return quote.response_code if quote.response_code != 200
      if Date.strptime(quote.last_trade_date, "%m/%d/%Y") >= self.result_date
        self.closing_price = quote.previous_close
        self.save
      end
      return quote.ask
    else
      return self.closing_price
    end

  end

end
