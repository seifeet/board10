require 'spec_helper'

describe "ownerships/new.html.erb" do
  before(:each) do
    assign(:ownership, stub_model(Ownership,
      :user_id => 1,
      :group_id => 1
    ).as_new_record)
  end

  it "renders new ownership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ownerships_path, :method => "post" do
      assert_select "input#ownership_user_id", :name => "ownership[user_id]"
      assert_select "input#ownership_group_id", :name => "ownership[group_id]"
    end
  end
end
