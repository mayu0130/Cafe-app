FactoryBot.define do
  factory :user do
    email { "user_#{rand(1000..9999)}@example.com" }
    password { 'password' }
  end
end
