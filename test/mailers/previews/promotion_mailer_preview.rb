# Preview all emails at http://localhost:3000/rails/mailers/promotion_mailer
class PromotionMailerPreview < ActionMailer::Preview
  def promotion_email
    @promotion_form = PromotionForm.new(:subject => "Promotion email",
                                        :recipient_team => Team.first,
                                        :promotional_text => "Here is your promotion",
                                        :venue_name => "Euphoria Cigar & Hookah Lounge")
    PromotionMailer.with(promotion: @promotion_form).promotion_email
  end
end
