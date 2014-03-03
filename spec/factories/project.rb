FactoryGirl.define do
  factory :project do
    sequence(:title) { |n| "ti#{n}tle" }
    sticky false
  end
end
