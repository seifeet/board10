require 'spec_helper'

describe "boards/edit.html.erb" do
  before(:each) do
    @board = assign(:board, stub_model(Board,
      :title => "MyString",
      :description => "MyText",
      :view_count => 1,
      :active => false,
      :access_level => 1
    ))
  end

  it "renders the edit board form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boards_path(@board), :method => "post" do
      assert_select "input#board_title", :name => "board[title]"
      assert_select "textarea#board_description", :name => "board[description]"
      assert_select "input#board_view_count", :name => "board[view_count]"
      assert_select "input#board_active", :name => "board[active]"
      assert_select "input#board_access_level", :name => "board[access_level]"
    end
  end
end
