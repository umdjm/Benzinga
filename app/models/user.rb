class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :current_streak, :max_streak

  validates_uniqueness_of :email
  has_many :stock_picks

  def update_streaks
    curr_streak = 0
    max_streak = 0
    self.stock_picks.order(:id).each do |pick|
      if pick.success
        curr_streak++
        max_streak = curr_streak if curr_streak > max_streak
      elsif !pick.success.nil?
        curr_streak = 0
      end
    end
    self.current_streak = curr_streak
    self.max_streak = max_streak
    self.save
  end

  def self.update_all_streaks
    StockPick.update_all_statuses
    sql = "UPDATE Users AS u
          SET current_streak = COUNT(s.ID)"
    ActiveRecord::Base.connection.execute(sql)
  end
end
