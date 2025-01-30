FactoryBot.define do
  factory :post do
    cafe_name { "Test Cafe" }
    body { "A nice cafe to enjoy coffee." }
    address { "123 Test Street" }
    cafe_link { "http://testcafe.com" }
    user
  end
end