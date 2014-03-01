class UsersController < ApplicationController

  before_filter :authorize, :except  => [:create, :new]

  def new
    @user = User.new
  end

  def index
    @day = params[:day]
    @current_leaders = User.order(:current_streak).limit(20)
    @all_time_leaders = User.order(:max_streak).limit(20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = current_user

    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/results", notice: "Thank you for signing up!"
    else
      render "new"
    end
  end
end
