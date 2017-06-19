require 'rails_helper'

describe Event do
  let(:tom) { create(:user, name: 'tom') }
  let(:jerry) { create(:user, name: 'jerry', email: 'jerry@gmail.com', mobile: '1582856690') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  let(:project) { create(:project, operator: tom, team_id: team.id, team_uid: team.uid) }
  let(:todolist) {create(:todolist, operator: tom, project_id: project.id, project_uid: project.uid, user_id: tom.id)}
  let(:todo) { create(:todo, user_id: tom.id, project_id: project.id,
                      project_uid: project.uid, operator: tom, todolist_id: todolist.id) }
  let(:comment) { create(:comment, operator: tom, todo_id: todo.id, user_id: tom.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  context '#scope' do
    # TODO: filter by access
    context '#by_team' do

    end

    context '#search' do
      it 'when opts is project_uid or user_uid, should return filter data' do
        create(:project, operator: jerry, team_id: team.id)
        expect(Event.search(user_uid: jerry.uid).count).to eq(2)
      end
    end
  end

  context '#action_display' do
    it '#comment_add_action_display show special info for comment add' do
      expect(comment.events.add.first.action_display).to eq('回复 任务')
    end

    context '#todo_assign_action_display show special info for todo assgin' do
      it 'if assigner is blank & assignee is present' do
        todo.to_assign!(0, tom.id)
        expect(todo.events.assign.first.action_display).to eq('给 tom指派了 任务')
      end

      it 'if assigner is present & assignee is blank' do
        todo.to_assign!(tom.id, 0)
        expect(todo.events.assign.first.action_display).to eq('取消了tom的 任务')
      end

      it 'if assigner is present & assignee is present' do
        todo.to_assign!(tom.id, jerry.id)
        expect(todo.events.assign.first.action_display).to eq('把 tom的任务指派给jerry')
      end
    end

    context '#todo_change_deadline_action_display' do
      it 'give a deadline to a new todo' do
        todo.to_change_deadline! nil, Time.parse('2018-01-01 00:00')
        display = todo.events.change_deadline.first.action_display
        expect(display).to eq('将 任务 完成时间 从 没有截止日期 修改为 2018-01-01 00:00:00')
      end

      it 'change the deadline for this todo' do
        todo.to_change_deadline! Time.parse('2018-01-01 00:00'), Time.parse('2018-01-02 00:00')
        display = todo.events.change_deadline.first.action_display
        expect(display).to eq('将 任务 完成时间 从 2018-01-01 00:00:00 修改为 2018-01-02 00:00:00')
      end

      it 'cancel the deadline for this todo' do
        todo.to_change_deadline! Time.parse('2018-01-02 00:00'), nil
        display = todo.events.change_deadline.first.action_display
        expect(display).to eq('将 任务 完成时间 从 2018-01-02 00:00:00 修改为 没有截止日期')
      end
    end

    context 'others action display' do
      it 'todo add action display should show common action info' do
        expect(todo.events.add.first.action_display).to eq('创建 任务')
      end

      it 'project add action display should show common action info' do
        expect(project.events.add.first.action_display).to eq('创建 项目')
      end
    end
  end

  context '#resource_name_display' do
    it '#comment_resource_name' do
      expect(comment.events.add.first.resource_name_display).to eq('任务')
    end

    it 'others resource name' do
      expect(project.events.add.first.resource_name_display).to eq('项目')
    end
  end

  # TODO:
  context '#resource_detail' do
    it '#comment_resource_detail should return comment resource ' do
      url = url_helpers.project_todo_path(comment.todo.project_uid, comment.todo)
      response = {
        name: comment.todo.name,
        link: "#{url}##{comment.uid}",
        content: comment.content
      }
      expect(comment.events.add.last.resource_detail).to eq(response)
    end

    it '#todo_resource_detail should return todo resource' do
      response = {
        name: todo.name,
        link: url_helpers.project_todo_path(todo.project_uid, todo),
        content: nil
      }
      expect(todo.events.add.last.resource_detail).to eq(response)
    end

    it '#todolist_resource_detail should return todolist resource' do
      response = {
        name: todolist.name,
        link: url_helpers.project_todolist_path(todolist.project_uid, todolist),
        content: nil
      }
      expect(todolist.events.add.last.resource_detail).to eq(response)
    end

    it '#team_resource_detail should return team resource' do
      response = {
        name: team.name,
        link: url_helpers.team_projects_path(team),
        content: nil
      }
      expect(team.events.add.last.resource_detail).to eq(response)
    end

    it '#project_resource_detail should return project resource' do
      response = {
        name: project.name,
        link: url_helpers.team_project_path(project.team_uid, project),
        content: nil
      }
      expect(project.events.add.last.resource_detail).to eq(response)
    end
  end
end