class TeamForm
  include ActiveModel::Model

  attr_accessor :name, :players, :game

  def players_attributes=(attributes)
    @players ||= []
    attributes.each do |i, attributes|
      @players.push(PlayerForm.new(attributes))
    end
  end

  def create_team_with_players(game, params)
    set_attributes(params)
    ActiveRecord::Base.transaction do
      team = game.teams.build(:name => params[:team][:name])
      params[:team][:players_attributes].each { |i, attributes|
        create_roster_and_player(team, attributes)
      }
      team.save!
    end
    rescue Exception => e
      errors.add(:base, e.message)
      false
  end

  def update_team_with_players(team, params)
    set_attributes(params)
    ActiveRecord::Base.transaction do
      params[:team][:players_attributes].each { |i, attributes|
        index = i.to_i
        if attributes.has_key?(:delete)
          player_id, roster_id, delete = attributes[:id].to_i, attributes[:roster_id].to_i, attributes[:delete]
          if delete == "1" || team.players[index].roster_id != roster_id
            team.players[index].destroy
            team.players.build(:roster_id => roster_id) if delete == "0" and roster_id > 0
          end
        else
          create_roster_and_player(team, attributes)
        end
      }
      team.name = params[:team][:name]
      team.save!
    end
  rescue Exception => e
    errors.add(:base, e.message)
    false
  end

  private
    def create_roster_and_player(team, attributes)
      name, email, newsletter = attributes[:roster_name], attributes[:roster_email], attributes[:roster_newsletter]
      roster = Roster.find_or_create_new(attributes[:roster_id], name, email)
      team.players.build(:roster => roster) unless roster.nil?
      team.game.venue.subscribe(roster, newsletter) if !name.empty? && !email.empty? && !roster.nil?
    end

    def set_attributes(params)
      @name = params[:team][:name]
      @players ||= []
      params[:team][:players_attributes].each { |i, attributes|
        @players.push(PlayerForm.new(attributes))
      }
    end

end
