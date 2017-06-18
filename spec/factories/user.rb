FactoryGirl.define do
  factory :user do
    name { 'jerry' }
    email { 'jerrery520@gmail.com' }
    mobile { '15828566956' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end