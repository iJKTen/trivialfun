class Admin::VenuesController < ApplicationController
  before_action :super_user_only, only: [:new, :create, :destroy]
  before_action :venue_only, only: [:index, :show, :edit, :update, :statistics, :subscriptions]
  before_action :get_venue, only: [:show, :edit, :update, :destroy, :statistics, :subscriptions]

  def index
    if current_user.super_user?
      @venues = Venue.all
    else
      @venues = current_user.venues
    end
  end

  def show
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    respond_to do |format|
      if @venue.save
        format.html { redirect_to admin_venues_path, notice: 'Venue was successfully created.' }
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
      if @venue.update(venue_params)
        format.html { redirect_to admin_venues_path, notice: 'Venue was successfully updated.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to admin_venues_path, notice: 'Venue was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def statistics
    @most_wins_by_teams = @venue.most_wins_by_teams
    @most_wins_by_player = @venue.most_wins_by_player
    @most_player_played = @venue.most_player_played
    @most_tiebreaker_playing_teams = @venue.most_tiebreaker_playing_teams
    @most_tiebreaker_winning_teams = @venue.most_tiebreaker_winning_teams
  end

  def subscriptions
    @subscriptions = Subscription.where(:venue => @venue)
    @subscriptions = @subscriptions.sort{|a,b| b.roster.times_played <=> a.roster.times_played}
  end

  private
    def super_user_only
      redirect_to "/" unless user_signed_in? and current_user and current_user.super_user?
    end

    def venue_only
      redirect_to "/" unless user_signed_in? and current_user and
                (current_user.super_user? || current_user.admin? || current_user.host?)
    end

    def venue_params
      params.require(:venue).permit(:name, :address, :phone, :to_email,
                                    :total_rounds_per_game, :total_questions_per_round,
                                    :maximum_players_per_team, :time_to_answer_question_in_seconds)
    end

    def get_venue
      @venue = Venue.find(params[:id])
    end
end
