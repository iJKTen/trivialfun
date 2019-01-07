class Admin::AccountsController < ApplicationController
  before_action :super_user_only
  before_action :get_venue
  before_action :get_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = @venue.users
  end

  def show
  end

  def new
    @user = @venue.users.build
  end

  def create
    @venue.users.new(user_params)
    respond_to do |format|
      if @venue.save
        format.html { redirect_to admin_venue_accounts_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_venue_accounts_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_venue_accounts_path, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def super_user_only
      redirect_to "/" unless user_signed_in? and current_user and current_user.super_user?
    end

    def get_venue
      @venue = Venue.find(params[:venue_id])
    end

    def get_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :role, :password, :password_confirmation)
    end
end
