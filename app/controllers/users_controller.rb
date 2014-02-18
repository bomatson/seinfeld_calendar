class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    build_calendar
    check_for_new_tasks_for(@user)
  end

  private

  def check_for_new_tasks_for(user)
    tracker = Tracker.new(user)
    tracker.run!
  end

  def build_calendar
    @tasks = @user.tasks
    @tasks_by_date = @tasks.group_by(&:format_date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def user_params
    params.require(:user).permit(:github_username)
  end
end
