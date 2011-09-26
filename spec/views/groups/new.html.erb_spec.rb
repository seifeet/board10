require 'spec_helper'

describe "boards/new.html.erb" do
  before(:each) do
    assign(:board, stub_model(Board,
      :title => "MyString",
      :description => "MyText",
      :view_count => 1,
      :active => false,
      :access_level => 1
    ).as_new_record)
  end

  it "renders new board form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boards_path, :method => "post" do
      assert_select "input#board_title", :name => "board[title]"
      assert_select "textarea#board_description", :name => "board[description]"
      assert_select "input#board_view_count", :name => "board[view_count]"
      assert_select "input#board_active", :name => "board[active]"
      assert_select "input#board_access_level", :name => "board[access_level]"
    end
  end
end
