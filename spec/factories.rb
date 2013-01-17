FactoryGirl.define do
	factory :user do
		name "Boaz Cohen"
		email "boaz@gmail.com"
		password "foobar"
		password_confirmation "foobar"
	end
end