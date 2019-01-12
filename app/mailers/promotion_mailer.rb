class PromotionMailer < ApplicationMailer
  def promotion_email
    @promotion = params[:promotion]
    @promotion.recipient_team.players.each { |player|
      @promotion.player = player
      mail(to: player.roster_email, subject: @promotion.subject)
    }
  end
end
