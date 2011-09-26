require 'spec_helper'

describe "ownerships/edit.html.erb" do
  before(:each) do
    @ownership = assign(:ownership, stub_model(Ownership,
      :user_id => 1,
      :board_id => 1
    ))
  end

  it "renders the edit ownership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ownerships_path(@ownership), :method => "post" do
      assert_select "input#ownership_user_id", :name => "ownership[user_id]"
      assert_select "input#ownership_board_id", :name => "ownership[board_id]"
    end
  end
end
