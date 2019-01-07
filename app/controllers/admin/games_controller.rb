class Admin::GamesController < ApplicationController
  before_action :venue_only
  before_action :get_venue, only: [:index, :new, :create]
  before_action :get_game, only: [:show, :edit, :update, :destroy,
                                  :play, :check_score, :tiebreaker, :winner]
  before_action :allow_open_game, only: [:edit, :update, :destroy]

  def index
    @games = @venue.ordered_games
  end

  def show
  end

  def new
    @game = Game.new_game_for_venue(@venue)
  end

  def create
    @game = @venue.games.new(game_params)
    respond_to do |format|
      if @venue.save
        format.html { redirect_to admin_venue_games_path(@venue), notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: admin_venue_games_path(@venue) }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
    #render plain: params[:game].inspect
  end

  def edit

  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to admin_venue_games_path(@game.venue), notice: 'Game was successfully updated.' }
        format.json { render :show, status: :created, location: admin_venue_games_path(@game.venue) }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @venue = @game.venue
    @game.destroy
    respond_to do |format|
      format.html { redirect_to admin_venue_games_path(@venue), notice: 'Game was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def play
    if @game.won
      redirect_to admin_venue_games_path(@game.venue)
    else
      render layout: 'play'
    end
  end

  def check_score
    @game.create_tiebreaker_teams
    if @game.winner.nil? && @game.teams_tied.count > 1
      redirect_to tiebreaker_admin_game_path(@game)
    else
      @game.sort_teams_by_score.first.make_winner
      redirect_to winner_admin_game_path(@game)
    end
  end

  def tiebreaker
    @question = @game.tiebreaker_question
    if !@question.nil? && @game.teams_tied.count > 1
      render layout: 'play'
    else
      redirect_to admin_venue_games_path(@game.venue)
    end
  end

  def winner
    render layout: 'play'
  end

  private
    def venue_only
      redirect_to "/" unless user_signed_in? and current_user and
                (current_user.super_user? || current_user.admin? || current_user.host?)
    end

    def get_venue
      if current_user.super_user?
        @venue = Venue.find(params[:venue_id])
      else
        @venue = Venue.joins(:users).where("users.id = #{current_user.id}")
                                    .where("venues.id = #{params[:venue_id]}").limit(1).first
      end
    end

    def get_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:title, :date,
                                    rounds_attributes: [:id, :order, :title, :category_id,
                                    questions_attributes: [:id, :order, :title, :answer]])
    end

    def allow_open_game
      raise ActionController::RoutingError.new('Not Found') if @game.won
    end
end
