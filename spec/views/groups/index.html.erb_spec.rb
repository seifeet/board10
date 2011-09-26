require 'spec_helper'

describe "boards/index.html.erb" do
  before(:each) do
    assign(:boards, [
      stub_model(Board,
        :title => "Title",
        :description => "MyText",
        :view_count => 1,
        :active => false,
        :access_level => 1
      ),
      stub_model(Board,
        :title => "Title",
        :description => "MyText",
        :view_count => 1,
        :active => false,
        :access_level => 1
      )
    ])
  end

  it "renders a list of boards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
