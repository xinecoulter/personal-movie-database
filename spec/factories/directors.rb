FactoryGirl.define do
  factory :director do
    name { Forgery::Name.full_name }
  end
end
