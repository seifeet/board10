namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:first_name => "Simple",
    :last_name => "Example",
    :email => "Simple.Example@gmail.com",
    :password => "passme19",
    :password_confirmation => "passme19")
    admin.toggle!(:admin)

    99.times do |n|
      first_name  = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "Simple.Example-#{n+1}@gmail.com"
      password  = "password"
      User.create!(:first_name => first_name,
      :last_name => last_name,
      :email => email,
      :password => password,
      :password_confirmation => password)
    end

    99.times do |n|
      title = Faker::Lorem.sentence(5)
      description = Faker::Lorem.sentence(5)
      Group.create!(:title => title,
      :description => description)
    end
    User.all(:limit => 6).each do |user|
      Group.all(:limit => 6).each do |group|
        50.times do
          posting = Posting.new
          posting.user_id = user.id
          posting.group_id = group.id
          posting.subject = Faker::Lorem.sentence(5)
          posting.content = Faker::Lorem.sentence(5)
          posting.save!
        end
      end
    end
  end
end