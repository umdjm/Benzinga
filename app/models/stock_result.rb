class StockResult < ActiveRecord::Base
  attr_accessible :result_date, :stock, :closing_price, :current_price
  has_many :stock_picks

  def closing_time
    Time.parse(self.result_date.to_s).change(:hour => 16)
  end

  def market_open
    return true if self.closing_price.nil?
    return false
  end

  def price
    return market_open ? self.current_price : self.closing_price
  end

  def self.retrieve_quotes
    url = CONFIG[:quote_url] + CONFIG[:stock_list].join(',')
    result = HTTParty.get(url)
    return nil if result.response.code != "200"
    return result.parsed_response
  end

  def self.update_prices
    quotes = StockResult.retrieve_quotes
    return if quotes.nil?

    StockResult.where(:closing_price => nil).each do |result|
      quote = quotes[result.stock]
      quote_time = Time.at(quote["asktime"]/1000)
      result.current_price = quote["ask"]
      result.closing_price = quote["ask"] if quote_time >= result.closing_time
      result.save
    end
  end

  def self.create_next_day
    return unless StockResult.where(:closing_price => nil).last.nil?
    quotes = StockResult.retrieve_quotes
    return if quotes.nil?

    stock_date = Time.now
    weekdays = 1..5
    stock_date += 1.day until stock_date > Time.now && weekdays.member?(stock_date.wday)

    quotes.each do |record|
      quote = record[1]
      newRecord = StockResult.new(:result_date => stock_date, :stock => quote["ipfSymbol"], :current_price => quote["ask"])
      newRecord.save
    end
  end

end
