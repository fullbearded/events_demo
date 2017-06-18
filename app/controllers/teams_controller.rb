class TeamsController < ApplicationController
  def create
    team = Team.new(params.permit(:name).merge(operator: current_user))
    if team.save
      render status: :ok, json: { message: :success }
    else
      render status: :unprocessable_entity, json: {
        message: :unprocessable_entity, data: team.errors
      }
    end
  end
end
