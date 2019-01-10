class PagesController < ApplicationController
  before_action :login_user_only, only: [:credits]

  def home
  end

  def admin
  end

  def credits

  end
  private
    def login_user_only
      redirect_to "/" unless user_signed_in?
    end
end
