class PromotionMailer < ApplicationMailer
  def promotion_email
    @team = params[:team]
    @subject = params[:subject]
    @promotional_text = params[:promotional_text]

    @team.players.each { |player|
      subscribed = Subscription.where(roster_id: player.roster_id)
                               .where("newsletter = true").count

      if subscribed = 1
        @player_name = player.roster.name
        mail(from: @team.game.venue.email,
               to: player.roster_email,
          subject: @subject)
      end
    }
  end
end
