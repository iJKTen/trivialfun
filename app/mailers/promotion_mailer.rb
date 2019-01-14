class PromotionMailer < ApplicationMailer
  def promotion_email
    @team = params[:team]
    @subject = params[:subject]
    @promotional_text = params[:promotional_text]
    @venue_name = @team.game.venue.name
    @team.players.each { |player|
      subscribed = Subscription.where(roster_id: player.roster_id)
                               .where("newsletter = true").count

      if subscribed = 1
        @player_name = player.roster.name
        mail(to: player.roster_email, subject: @subject)
      end
    }
  end
end
