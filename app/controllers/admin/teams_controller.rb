class Admin::TeamsController < ApplicationController
  before_action :venue_only
  before_action :get_game, only: [:index, :new, :create]
  before_action :get_team, only: [:show, :edit, :update, :destroy, :answer, :answered]
  before_action :allow_open_game, only: [:edit, :update, :destroy, :answer, :answered]

  respond_to :html, :json

  def index
    @teams = @game.teams
    respond_with(@teams)
  end

  def show
  end

  def new
    @team = TeamForm.new(:game => @game)
    @team.players = @game.venue.maximum_players_per_team.times.map { PlayerForm.new() }
  end

  def create
    @team = TeamForm.new(:game => @game)

    respond_to do |format|
      if @team.create_team_with_players(@game, params)
        format.html { redirect_to admin_game_teams_path(@game), notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: admin_game_teams_path(@game) }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @team.add_open_player_slot_if_available
  end

  def update
    @team_form = TeamForm.new(:name => params[:team][:name])
    respond_to do |format|
      if @team_form.update_team_with_players(@team, params)
        format.html { redirect_to admin_game_teams_path(@team.game), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :created, location: admin_game_teams_path(@team.game) }
      else
        format.html { render :edit }
        format.json { render json: @team_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game = @team.game
    @team.destroy
    respond_to do |format|
      format.html { redirect_to admin_game_teams_path(@game), notice: 'Team was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def answer
  end

  def answered
    respond_to do |format|
      if @team.update_answers(params)
        format.html { redirect_to admin_game_teams_path(@team.game), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :created, location: admin_game_teams_path(@team.game) }
      else
        format.html { render :answer }
        format.json { render json: @team_form.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def venue_only
      redirect_to "/" unless user_signed_in? and current_user and
                (current_user.super_user? || current_user.admin? || current_user.host?)
    end

    def get_game
      if current_user.super_user?
        @game = Game.find(params[:game_id])
      else
        @game = Game.joins(venue: [:users]).where("users.id = #{current_user.id}")
                                    .where("games.id = #{params[:game_id]}").limit(1).first
      end
    end

    def get_team
      @team = Team.find(params[:id])
    end

    def allow_open_game
      raise ActionController::RoutingError.new('Not Found') if @team.game.won
    end
end
