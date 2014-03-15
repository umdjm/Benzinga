class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :current_streak, :max_streak, :name, :incorrect_count, :correct_count, :current_rank, :max_rank

  has_many :stock_picks
  has_many :notifications

  after_initialize :default_values, if: 'new_record?'
  def default_values
    total_user_count = User.count
    self.max_streak = 0
    self.current_streak = 0
    self.incorrect_count = 0
    self.correct_count = 0
    self.current_rank = total_user_count
    self.max_rank = total_user_count
  end

  def record
    return self.correct_count.to_s + "-" + self.incorrect_count.to_s
  end

  def update_streaks
    return unless StockResult.where(:closing_price => nil).last.nil?
    self.current_streak = 0
    self.max_streak = 0
    self.correct_count = 0
    self.incorrect_count = 0
    self.stock_picks.order(:id).each do |pick|
      if pick.success
        self.correct_count = self.correct_count + 1
        self.current_streak = self.current_streak + 1
        self.max_streak = self.current_streak if self.current_streak > self.max_streak
      elsif !pick.success.nil?
        self.incorrect_count = self.incorrect_count + 1
        self.current_streak = 0
      end
    end
    self.save
  end

  def self.update_all_rankings
    return unless StockResult.where(:closing_price => nil).last.nil?
    rank = 1
    ActiveRecord::Base.transaction do
      User.order("max_streak desc, current_streak desc").each do |user|
        user.max_rank = rank
        rank = rank + 1
        user.save
      end
    end
    rank = 1
    ActiveRecord::Base.transaction do
      User.order("current_streak desc, max_streak desc").each do |user|
        user.current_rank = rank
        rank = rank + 1
        user.save
      end
    end
  end

  def self.update_all_streaks
    User.all.each do |u|
      u.update_streaks
    end
  end
end
