FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "foo#{n}" }
    password "password"
    password_confirmation "password"
    email { "#{name}@example.com" }
  end

end
