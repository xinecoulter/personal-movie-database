FactoryGirl.define do
  factory :movie_actor do
    association :movie
    association :actor
  end
end
