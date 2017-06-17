class EventsController < ApplicationController
  def index
    filter = params.slice(:project_uid, :user_uid, :team_uid)
    @events = Event.query(filter).page(format_page)
  end
end
