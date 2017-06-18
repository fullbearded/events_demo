# ActiveRecord::Base.logger = Logger.new(STDOUT)

%w(superadmin admin member visitor).each do |role_name|
  Role.find_or_create_by name: role_name
end

# import development initialize data
if Rails.env.development?
  puts '1. import users'
  {jerry: '15828566956', alice: '15828566950', tom: '15828566951'}.each do |name, mobile|
    user = User.find_or_initialize_by name: name
    password = '12345678'
    user.assign_attributes password: password, password_confirmation: password,
                           email: "#{name}@gmail.com", mobile: mobile
    user.save
  end

  user = User.find_by name: 'jerry'

  puts '2. import teams'
  %w(superman spider_man).each do |name|
    team = Team.find_or_initialize_by name: name
    team.operator = user
    team.save
  end

  puts '3. binding user & team, all user joins team'
  Team.all.each do |team|
    User.find_each do |user|
      team.users << user
    end
  end

  puts '4. import project && create default todolist'
  superman_team = Team.find_by name: 'superman'
  {zod: 'Genering zod', krypton: 'superman homeplanet'}.each do |name, desc|
    superman_team.generate_project!(user, name: name, description: desc)
  end

  puts %q(
    5. set the authority:
      in superman team zod project: jerry is admin, alice is member, tom is visitor,
      in superman team krypton: jerry is member, tom is visitor
  )


  puts '6. import todos'
  todolist = Project.find_by(name: 'zod').todolists.first
  author = User.find_by name: 'jerry'
  todolist.generate_todos!(author, {
    name: 'Genering zod kill by superman',
    description: 'Genering zod kill by superman in earth'
  })
  todolist.generate_todos!(author, {
    name: 'Genering zod release',
    description: 'because of krypton destroyed, Genering zod released from prison'
  })

  puts '7. import comments'
  todo = todolist.todos.first
  commenter = User.find_by name: 'tom'
  todo.generate_comments! commenter, content: 'I love superman'

  puts '8. events traces'
  todo.operator = user
  puts '8.0 create a new todolist'
  project = Project.find_by(name: 'zod')
  project.operator = user
  other_todolist = project.generate_todolist!('zod new todolist')
  puts '8.1 move task to new todolist'
  todo.to_move! other_todolist.id

  puts '8.2.1 jerry build a task, assign to tom'
  tom = User.find_by name: 'tom'
  todo.to_assign! todo.assignee.try(:id).to_i, tom.id
  puts '8.2.2 jerry change the tom to alice'
  alice = User.find_by name: 'alice'
  todo.to_assign! todo.reload.assignee.try(:id).to_i, alice.id
  puts '8.2.3 jerry cancel the task assigness'
  todo.to_assign! todo.reload.assignee.try(:id).to_i, 0

  puts '8.3 change deadline'
  todo.to_change_deadline! todo.deadline, 1.days.since
  todo.to_change_deadline! todo.deadline, 10.days.since
  todo.to_change_deadline! todo.deadline, nil

  puts '8.4 finished todo'
  todo.to_close!

  puts '8.5 remove todo'
  todo.destroy

  puts '9 betch over 50 data'
  zod_todolist = Project.find_by(name: 'zod').todolists.first
  50.times.each do |n|
    author = User.find_by name: 'tom'
    zod_todolist.generate_todos!(author, {
      name: "Genering zod killed #{n}",
      description: 'Genering zod killed everyday'
    })
  end

end
