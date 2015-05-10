FactoryGirl.define do
  factory :movie_director do
    association :movie
    association :director
  end
end
