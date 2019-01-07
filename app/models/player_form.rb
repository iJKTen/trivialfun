class PlayerForm
  include ActiveModel::Model

  attr_accessor :id, :roster_id, :roster_name, :roster_email, :roster_newsletter, :delete

  def initialize(params = nil)
    if !params.nil?
      @id = params[:id].empty? ? nil : params[:id]
      @roster_id = params[:roster_id]
      @delete = params[:delete] if params.has_key?(:delete)
      @roster_name = params[:roster_name] if params.has_key?(:roster_name)
      @roster_email = params[:roster_email] if params.has_key?(:roster_email)
      @roster_newsletter = params[:roster_newsletter] if params.has_key?(:roster_newsletter)
    end
  end
end
