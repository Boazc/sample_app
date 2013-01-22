require 'spec_helper'

describe Micropost do
  
  	let(:user) {FactoryGirl.create(:user)}
  	
  	before do
  		@micropost = user.microposts.build(content: "lorem ipsum")
  	end

	subject { @micropost }

	it {should respond_to :content}
	it {should respond_to :user_id}
	it {should respond_to :user}
	its(:user) { should == user }

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Micropost.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user id is nil" do
		before {@micropost.user_id = nil}
		it {should_not be_valid}
	end	

	describe "with content that is too long" do
		before { @micropost.content = "a" * 141 }
		it { should_not be_valid }
	end

	
	


end
