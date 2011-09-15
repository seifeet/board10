require 'spec_helper'

describe "members/show.html.erb" do
  before(:each) do
    @member = assign(:member, stub_model(Member,
      :user_id => 1,
      :group_id => 1,
      :owner => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
