FactoryGirl.define do
  sequence(:random_name) { |n| Forgery(:lorem_ipsum).words(1).capitalize }

  factory :genre do
    name { generate(:random_name) }
  end
end
