class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionHelper

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def self.default_url_options
    {locale: I18n.locale}
  end

  def authenticate_user!
    return if logged_in?
    flash[:danger] = t "login.required"
    redirect_to login_url
  end
end
