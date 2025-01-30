FactoryBot.define do
  factory :comment do
    content { "これはテストコメントです" }
    association :user
    association :post
  end
end
