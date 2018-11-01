10.times do |n|
  name = FFaker::NameVN.name
  email = "user#{n + 1}@gmail.com"
  password = "12345678"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
users = User.order(:created_at).take(6)
10.times do
  name = FFaker::Name.name
  content = FFaker::Lorem.sentence(4)
  project = Project.create!(name: name, describe: content)
  users.each {|user| user.projects << project}
  rand(2..5).times do
    name = FFaker::Name.name
    task = project.tasks.create! name: name
    rand(0..3).times do
      card = task.cards.create! name: FFaker::Name.name,
        user_id: User.order("RAND()").first.id
      rand(2..4).times do
        card.events.create! user_id: User.order("RAND()").first.id,
          content: FFaker::Lorem.sentence(2),
          event_type: :comment
      end
    end
  end
end
admin = User.create!(name: "admin",
  email: "admin@gmail.com",
  password: "12345678",
  password_confirmation: "12345678")

Project.all.each do |project|
  project.relationships.create! user_id: admin.id, is_manager: 1
end
