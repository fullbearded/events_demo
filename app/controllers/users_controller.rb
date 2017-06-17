class UsersController < ApplicationController
  def index
    team = Team.find_by uid: params[:team_uid]
    @users = team.users
  end
end
