class PromotionMailer < ApplicationMailer
  def promotion_email
    # @promotion = params[:promotion]
    @team = params[:team]
    @subject = params[:subject]
    @team.players.each { |player|
      mail(to: player.roster_email, subject: @subject)
    }
  end
end
