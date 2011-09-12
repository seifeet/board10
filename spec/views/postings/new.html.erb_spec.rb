require 'spec_helper'

describe "postings/new.html.erb" do
  before(:each) do
    assign(:posting, stub_model(Posting,
      :group_id => 1,
      :active_group => false,
      :user_id => 1,
      :active_user => false,
      :visibility => 1,
      :subject => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new posting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postings_path, :method => "post" do
      assert_select "input#posting_group_id", :name => "posting[group_id]"
      assert_select "input#posting_active_group", :name => "posting[active_group]"
      assert_select "input#posting_user_id", :name => "posting[user_id]"
      assert_select "input#posting_active_user", :name => "posting[active_user]"
      assert_select "input#posting_visibility", :name => "posting[visibility]"
      assert_select "input#posting_subject", :name => "posting[subject]"
      assert_select "textarea#posting_content", :name => "posting[content]"
    end
  end
end
