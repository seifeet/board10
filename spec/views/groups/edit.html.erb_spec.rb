require 'spec_helper'

describe "groups/edit.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :title => "MyString",
      :description => "MyText",
      :view_count => 1,
      :active => false,
      :access_level => 1
    ))
  end

  it "renders the edit group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => groups_path(@group), :method => "post" do
      assert_select "input#group_title", :name => "group[title]"
      assert_select "textarea#group_description", :name => "group[description]"
      assert_select "input#group_view_count", :name => "group[view_count]"
      assert_select "input#group_active", :name => "group[active]"
      assert_select "input#group_access_level", :name => "group[access_level]"
    end
  end
end
