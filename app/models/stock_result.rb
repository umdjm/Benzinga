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

  def update_price
    quote = StockQuote::Stock.quote(self.stock)
    if quote.response_code == 200
      self.current_price = quote.ask
      self.closing_price = quote.previous_close if Date.strptime(quote.last_trade_date, "%m/%d/%Y") >= result.result_date
    end
  end

  def self.create_next_day
    return unless StockResult.where(:closing_price => nil).last.nil?
    stock_date = Time.now
    weekdays = 1..5
    stock_date += 1.day until stock_date > Time.now && weekdays.member?(stock_date.wday)

    CONFIG[:stock_list].each do |stock_symbol|
      newRecord = StockResult.new(:result_date => stock_date, :stock => stock_symbol)
      newRecord.save
    end
  end

end
