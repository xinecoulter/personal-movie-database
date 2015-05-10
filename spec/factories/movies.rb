FactoryGirl.define do
  sequence(:random_string) {|n| Forgery(:lorem_ipsum).words(3) }

  factory :movie do
    association :user
    title { generate(:random_string) }
  end
end
