User.create!(name: "test",
  email: "test@gmail.com",
  password: "12345678",
  password_confirmation: "12345678")

10.times do |n|
  name = FFaker::NameVN.name
  email = "example-#{n + 1}@spm.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
users = User.order(:created_at).take(6)
10.times do
  name = FFaker::Name.name
  content = FFaker::Lorem.sentence(5)
  project = Project.create!(name: name, describe: content)
  users.each {|user| user.projects << project}
end
projects = Project.all
5.times do
  name = FFaker::Name.name
  projects.each {|p| p.tasks.create!(project_id: p.id, name: name)}
end
