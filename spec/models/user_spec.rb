# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  email           :string(255)     not null
#  first_name      :string(150)     not null
#  last_name       :string(150)     not null
#  country         :string(150)
#  state           :string(2)
#  city            :string(150)
#  admin           :boolean(1)      default(FALSE)
#  active          :boolean(1)      default(TRUE)
#  view_count      :integer(4)      default(0)
#  remember_token  :string(255)
#  password_digest :string(255)
#  salt            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'



describe User do
# pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @attr = { :email => "user@example.com",
      :first_name => "FirstName",
      :last_name => "LastName",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  # The subsequent tests then check each validation in turn,
  # using the same @attr.merge technique first.
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a first name" do
    no_name_user = User.new(@attr.merge(:first_name => ""))
    no_name_user.should_not be_valid
  end

  it "should require a last name" do
    no_name_user = User.new(@attr.merge(:last_name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject :first_name that longer that 150 chars" do
    long_name = "a" * 151
    long_name_user = User.new(@attr.merge(:first_name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject :last_name that longer that 150 chars" do
    long_name = "a" * 151
    long_name_user = User.new(@attr.merge(:last_name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject :country that longer that 150 chars" do
    long_name = "a" * 151
    long_name_user = User.new(@attr.merge(:country => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject :city that longer that 150 chars" do
    long_name = "a" * 151
    long_name_user = User.new(@attr.merge(:city => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject :state that longer that 2 chars" do
    long_name = "a" * 3
    long_name_user = User.new(@attr.merge(:state => long_name))
    long_name_user.should_not be_valid
  end

  #it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
  #  User.create!(@attr)
  #  user_with_duplicate_email = User.new(@attr)
  #  user_with_duplicate_email.should_not be_valid
  #end
  #it "should reject email addresses identical up to case" do
  #  upcased_email = @attr[:email].upcase
  #  User.create!(@attr.merge(:email => upcased_email))
  #  user_with_duplicate_email = User.new(@attr)
  #  user_with_duplicate_email.should_not be_valid
  #end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have password_digest attribute" do
      @user.should respond_to(:password_digest)
    end

    it "should set the encrypted password" do
      @user.password_digest.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
  
  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      @group = Group.first()
      @mp1 = Factory(:posting, :user => @user, :group => group, :created_at => 1.day.ago)
      @mp2 = Factory(:posting, :user => @user, :group => group, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
  end
  
end
