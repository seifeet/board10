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

  #  99.times do |n|
  #    title = Faker::Lorem.sentence(5)
  #    description = Faker::Lorem.sentence(5)
  #    Board.create!(:title => title,
  #    :description => description)
  #  end
  #  User.all(:limit => 6).each do |user|
  #    Board.all(:limit => 6).each do |board|
  #      50.times do
  #        posting = Posting.new
  #        posting.user_id = user.id
  #        posting.board_id = board.id
  #        posting.subject = Faker::Lorem.sentence(5)
  #        posting.content = Faker::Lorem.sentence(5)
  #        posting.visibility = Random.rand(1)
  #        posting.access_level = Random.rand(1)
  #        posting.save!
  #      end
  #    end
  #  end
    
    # make_relationships
  #  users = User.all
  #  boards = Board.all
  #  user  = users.first
  #  user2 = users.second
  #  user3 = users.last
  #  ownerships = boards[1..25]
  #  memberships = boards[26..50]
  #  ownerships2 = boards[1..15]
  #  memberships2 = boards[16..50]
  #  ownerships3 = boards[10..30]
  #  memberships3 = boards[1..9]
  #  ownerships.each { |board| user.owner!(board.id) }
  #  memberships.each { |board| user.member!(board.id) }
  #  ownerships2.each { |board| user2.owner!(board.id) }
  #  memberships2.each { |board| user2.member!(board.id) }
  #  ownerships3.each { |board| user3.owner!(board.id) }
  #  memberships3.each { |board| user3.member!(board.id) }
  end
end