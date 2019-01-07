class ApplicationController < ActionController::Base

  protected
    def after_sign_in_path_for(resource)
      if current_user.super_user?
        admin_venues_path
      elsif current_user.admin? || current_user.host?
        if current_user.venues.count <= 1
          admin_venue_games_path(current_user.venues.first)
        else
          admin_venues_path
        end
      else
        root_url  #change once you have URL's
      end
    end
end
