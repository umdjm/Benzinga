class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :email, :password, :password_confirmation, :current_streak, :max_streak, :name, :incorrect_count, :correct_count

  validates_uniqueness_of :email
  has_many :stock_picks


  def record
    return self.correct_count.to_s + "-" + self.incorrect_count.to_s
  end

  def update_streaks
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

  def self.update_all_streaks
    User.all.each do |u|
      u.update_streaks
    end
  end
end
