class TodosController < ApplicationController
  def show
    @todo = Todo.find_by(params.permit(:project_uid, :uid))
  end
end
