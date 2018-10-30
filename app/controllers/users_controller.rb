class UsersController < ApplicationController
  before_action :load_user, except: %i(new create)
  before_action :logged_in_user, only: %i(edit update)
  before_action :correct_user, only: %i(edit update)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_to :root
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to new_user_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to :root unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "signup.user_not_found"
    redirect_to new_user_path
  end

end
