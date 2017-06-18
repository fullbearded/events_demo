class EventsController < ApplicationController
  def index
    filter = params.permit(:project_uid, :user_uid)
    @events = Event.by_team(params[:team_uid], current_user)
                   .includes(:user, :resource)
                   .search(filter).order(id: :desc).page(format_page)
  end
end
