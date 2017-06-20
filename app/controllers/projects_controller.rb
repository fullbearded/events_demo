class ProjectsController < ApplicationController
  skip_before_action :require_team
  before_action :set_current_team, only: [:index]

  def index
    @projects = Project.where(params.permit(:team_uid))
  end

  def show
    @project = Project.find_by(params.permit(:team_uid, :uid))
  end

  private

  def set_current_team
    session[:team_id] = Team.find_by(uid: params[:team_uid]).id
  end
end
