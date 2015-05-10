FactoryGirl.define do
  factory :actor do
    name { Forgery::Name.full_name }
  end
end
