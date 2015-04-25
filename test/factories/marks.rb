FactoryGirl.define do
  factory :mark do
    user
    marked_user_id  { create(:user).id }
  end
end
