FactoryBot.define do
  factory :profile do
    nickname { 'Test User' }
    introduction { 'Hello, this is a test user profile.' }
    mbti { 'INFP' }
    address { '123 Test Street' }
    x_link { 'https://example.com' }
    instagram_link { 'https://instagram.com/example' }
    user
  end
end
