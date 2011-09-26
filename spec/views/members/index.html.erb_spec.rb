require 'spec_helper'

describe "members/index.html.erb" do
  before(:each) do
    assign(:members, [
      stub_model(Member,
        :user_id => 1,
        :board_id => 1,
        :owner => false
      ),
      stub_model(Member,
        :user_id => 1,
        :board_id => 1,
        :owner => false
      )
    ])
  end

  it "renders a list of members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
