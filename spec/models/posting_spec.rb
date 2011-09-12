# == Schema Information
#
# Table name: postings
#
#  id           :integer(4)      not null, primary key
#  group_id     :integer(4)      not null
#  active_group :boolean(1)      default(TRUE)
#  user_id      :integer(4)      not null
#  active_user  :boolean(1)      default(TRUE)
#  visibility   :integer(4)      default(0)
#  subject      :string(255)
#  content      :text            default(""), not null
#  created_at   :datetime
#  updated_at   :datetime
#  access_level :integer(4)      default(0)
#

require 'spec_helper'

describe Posting do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.postings.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @posting = @user.postings.create(@attr)
    end

    it "should have a user attribute" do
      @posting.should respond_to(:user)
    end

    it "should have the right associated user" do
      @posting.user_id.should == @user.id
      @posting.user.should == @user
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
end
