require 'spec_helper'

describe "ownerships/show.html.erb" do
  before(:each) do
    @ownership = assign(:ownership, stub_model(Ownership,
      :user_id => 1,
      :group_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
