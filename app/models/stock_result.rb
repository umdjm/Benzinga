class StockResult < ActiveRecord::Base
  attr_accessible :result_date, :stock, :closing_price, :current_price
  has_many :stock_picks

  def closing_time
    Time.parse(sr.result_date.to_s + " 16:00:00 -0400")
  end

  def market_open
    return true if self.closing_price.nil?
    return false
  end

  def price
    return market_open ? self.current_price : self.closing_price
  end

  def self.retrieve_quotes(stock_list)
    url = CONFIG[:quote_url] + stock_list
    result = HTTParty.get(url)
    return nil if result.response.code != "200"
    return result.parsed_response
  end

  def self.update_prices
    stock_list = StockResult.where(:closing_price => nil).pluck(:stock).join(',')
    quotes = StockResult.retrieve_quotes(stock_list)
    return if quotes.nil?

    StockResult.where(:closing_price => nil).each do |result|
      quote = quotes[result.stock]
      quote_time = Time.at(quote["asktime"]/1000)
      result.current_price = quote["ask"]
      result.closing_price = quote["ask"] if quote_time >= result.closing_time
      result.save
    end
  end

  def self.next_weekday(original_date)
    one_day = 1.day
    result = original_date.at_midnight
    result += one_day until result > original_date.at_midnight && CONFIG[:weekdays].member?(result.wday) && !CONFIG[:market_closed].member?(result.yday)
    return result
  end

  def self.prev_weekday(original_date)
    one_day = 1.day
    result = original_date.at_midnight
    result -= one_day until result < original_date.at_midnight && CONFIG[:weekdays].member?(result.wday) && !CONFIG[:market_closed].member?(result.yday)
    return result
  end

  def self.create_next_day
    return unless StockResult.where(:closing_price => nil).last.nil?
    stock_date = StockResult.next_weekday(Time.now).in_time_zone("America/New_York").to_date
    return unless StockResult.where("result_date > ?", stock_date).last.nil?

    stock_list = CONFIG[:stock_list].join(',')
    quotes = StockResult.retrieve_quotes(stock_list)
    return if quotes.nil?

    quotes.each do |record|
      quote = record[1]
      newRecord = StockResult.new(:result_date => stock_date, :stock => quote["ipfSymbol"], :current_price => quote["ask"])
      newRecord.save
    end
  end

end
