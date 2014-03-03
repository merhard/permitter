FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}name" }

    factory :admin do
      admin true
    end

  end
end
