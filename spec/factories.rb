# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Michael"
  user.last_name             "Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :group do |group|
  group.description            "AboutMyGroup"
  group.title             "MyGroup"
end

Factory.define :posting do |posting|
  posting.content "Foo bar"
  posting.association :user
  posting.association :group
end