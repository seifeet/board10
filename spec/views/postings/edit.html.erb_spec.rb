require 'spec_helper'

describe "postings/edit.html.erb" do
  before(:each) do
    @posting = assign(:posting, stub_model(Posting,
      :board_id => 1,
      :active_board => false,
      :user_id => 1,
      :active_user => false,
      :visibility => 1,
      :subject => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit posting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postings_path(@posting), :method => "post" do
      assert_select "input#posting_board_id", :name => "posting[board_id]"
      assert_select "input#posting_active_board", :name => "posting[active_board]"
      assert_select "input#posting_user_id", :name => "posting[user_id]"
      assert_select "input#posting_active_user", :name => "posting[active_user]"
      assert_select "input#posting_visibility", :name => "posting[visibility]"
      assert_select "input#posting_subject", :name => "posting[subject]"
      assert_select "textarea#posting_content", :name => "posting[content]"
    end
  end
end
