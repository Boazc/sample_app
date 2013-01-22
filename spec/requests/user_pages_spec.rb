require 'spec_helper'

describe "UserPages" do
	subject { page }

	describe "Signup page" do
		before { visit signup_path }
		it {should have_selector 'h1', text: 'Sign up'}
		it {should have_selector 'title', text: full_title('Sign up')}
	end

	describe "profile page" do
		let (:user) {FactoryGirl.create(:user)}
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
	
		before { visit user_path(user) }

		it {should have_selector 'h1',    text: user.name}
		it {should have_selector 'title', text: user.name}

		describe "microposts" do
			it {should have_content(m1.content)}
			it {should have_content(m2.content)}
			it {should have_content(user.microposts.count)}
		end
	end

	describe "signup" do
		before { visit signup_path }
		
		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do

				before {click_button submit}

				it {should have_selector 'title', text:'Sign up'}
				it {should have_content 'error'}
				it {should_not have_content 'Password_digest'}
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",		with: "Boaz"
				fill_in "Email",	with: "user1@example.com"
				fill_in "Password",	with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving a user" do
				before {click_button submit}

				let (:user) {User.find_by_email("user1@example.com")}

				it { should have_selector('title', text: user.name)}
				it { should have_selector('div.alert.alert-success', text: 'Welcome')}
				it {should have_link('Profile', href: user_path(user))}
				it {should have_link('Sign out', href: signout_path)}
				it {should_not have_link('Sign in', href: signin_path)}
			end
		end
	end

	describe "edit" do
		let(:user) {FactoryGirl.create(:user)}
		before do
			visit signin_path
			fill_in "Email",	with: user.email
			fill_in "Password",	with: user.password
			click_button "Sign in"
			visit edit_user_path(user)
		end

		describe "page" do
			it {should have_selector 'h1', text: 'Update user profile'}
			it {should have_selector 'title', text: full_title('Edit page')}
		end

		describe "with invalid information" do
			before {click_button "Save changes"}

			it {should have_content('error')}
		end

		describe "with valid information" do
			let (:new_name) {"new name"}
			let (:new_mail) {"new@example.com"}

			before do
				fill_in "Name",       			with: new_name
				fill_in "Email",      			with: new_mail
				fill_in "Password",   			with: user.password
				fill_in "Confirm password",   	with: user.password
				
				click_button "Save changes"
			end

			it {should have_selector('title', text: new_name)}
			it {should have_selector('div.alert.alert-success', text: 'Profile updated')}
			it {should have_link('Sign out', href: signout_path)}

			specify {user.reload.name  = new_name}
			specify {user.reload.email = new_mail}
		end
	end
end
