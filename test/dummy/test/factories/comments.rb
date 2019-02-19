FactoryBot.define do
  factory :comment do
    post { nil }
    content { "Comment content" }
    author
  end
end
