class LaunchpadController < ApplicationController
  skip_before_action :require_team
  layout false
  def index
    @teams = current_user.teams
  end
end
