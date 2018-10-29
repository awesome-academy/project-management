class SessionController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to :root
    else
      flash[:danger] = t "login.wrong_login"
      render :new
    end
  end

  def new; end

  def destroy
    log_out
    redirect_to root_path
  end
end
