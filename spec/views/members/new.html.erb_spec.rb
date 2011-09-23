require 'spec_helper'

describe "members/new.html.erb" do
  before(:each) do
    assign(:member, stub_model(Member,
      :user_id => 1,
      :group_id => 1,
      :owner => false
    ).as_new_record)
  end

  it "renders new member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => members_path, :method => "post" do
      assert_select "input#member_user_id", :name => "member[user_id]"
      assert_select "input#member_group_id", :name => "member[group_id]"
      assert_select "input#member_owner", :name => "member[owner]"
    end
  end
end
