class StockPick < ActiveRecord::Base
  attr_accessible :prediction, :stock_result_id, :assigned_price

  DIRECTIONS = [DIRECTION_EMPTY = '', DIRECTION_UP = 'up', DIRECTION_DOWN = 'down']
  validates :prediction, inclusion: {in: DIRECTIONS}

  default_scope :include => :stock_result

  def prediction_long
    return "" if self.prediction.nil? || self.assigned_price.nil?
    return "#{self.prediction.humanize} from #{ActionController::Base.helpers.number_to_currency(self.assigned_price)}"
  end


  def result
    return "No Prediction" if self.prediction.nil? || self.assigned_price.nil?
    return "Current Pick" if self.stock_result.closing_price.nil?
    return "Correct" if self.success
    return "Incorrect"
  end

  def success
    return nil if ( self.prediction.nil? || self.assigned_price.nil?)
    return nil if self.stock_result.market_open
    change = self.stock_result.closing_price - self.assigned_price

    if change > 0 and self.prediction == DIRECTION_UP
      return true
    elsif change < 0 and self.prediction == DIRECTION_DOWN
      return true
    else
      return false
    end
  end

  belongs_to :stock_result
  belongs_to :user

  def self.update_all_statuses
    sql = "UPDATE stock_picks AS p
          SET success = (p.prediction = r.direction)
          FROM stock_results AS r
          WHERE r.direction != ''
            AND p.stock_result_id = r.id"
    ActiveRecord::Base.connection.execute(sql)
  end

end
