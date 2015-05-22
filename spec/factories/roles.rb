FactoryGirl.define do
  factory :role do
    association :movie
    association :actor
  end
end
