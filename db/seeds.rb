ActiveRecord::Base.logger = Logger.new(STDOUT)

%w(superadmin admin member visitor).each do |role_name|
  Role.find_or_create_by name: role_name
end

# import development initialize data
if Rails.env.development?
  # 1. import users
  {jerry: '15828566956', alice: '15828566950', tom: '15828566951'}.each do |name, mobile|
    user = User.find_or_initialize_by name: name
    password = '12345678'
    user.assign_attributes password: password, password_confirmation: password,
                           email: "#{name}@gmail.com", mobile: mobile
    user.save
  end

  user = User.find_by name: 'jerry'

  # 2. import teams
  %w(superman spider_man).each do |name|
    team = Team.find_or_initialize_by name: name
    team.operator = user
    team.save
  end

  # 3. binding user & team, all user joins team
  Team.all.each do |team|
    User.find_each do |user|
      team.users << user
    end
  end

  # 4. import project && create default todolist
  superman_team = Team.find_by name: 'superman'
  {zod: 'Genering zod', krypton: 'superman homeplanet'}.each do |name, desc|
    superman_team.generate_project!(user, name: name, description: desc)
  end

  # 5. set the authority: jerry is admin, alice is member, tom is visitor

  # 6. import todos
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

  # 7. import comments
  todo = todolist.todos.first
  commenter = User.find_by name: 'tom'
  todo.generate_comments! commenter, content: 'I love superman'


  # 8. events traces
  # 8.1 remove todo
  todo.operator = user
  todo.destroy


end
