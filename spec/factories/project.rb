FactoryGirl.define do
  factory :project do
    sequence (:title) { |n| "ti#{n}tle" }
  end
end
