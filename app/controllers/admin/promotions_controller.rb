class Admin::PromotionsController < ApplicationController
  before_action :venue_only, only: [:new, :create]
  before_action :get_venue, only: [:new, :create]

  def new
    @promotion_form = PromotionForm.new
    @winning_teams = @promotion_form.winning_teams(params[:venue_id])
  end

  def create
    @promotion_form = PromotionForm.new(promotional_params)
    @team = Team.find(@promotion_form.recipient_team)
    # @promotion_form.venue_name = @venue.name
    PromotionMailer.with(team: @team, subject: @promotion_form.subject).promotion_email.deliver_later
    respond_to do |format|
      format.html { redirect_to admin_venues_path, notice: 'Promotion was scheduled to be sent.' }
    end
  end

  private
    def get_venue
      @venue = Venue.find(params[:venue_id])
    end

    def venue_only
      redirect_to "/" unless user_signed_in? and current_user and
                (current_user.super_user? || current_user.admin? || current_user.host?)
    end

    def promotional_params
      params.require(:promotion_form).permit(:subject, :recipient_team, :promotional_text)
    end
end
