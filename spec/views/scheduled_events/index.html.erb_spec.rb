require 'spec_helper'

describe "scheduled_events/index.html.erb" do
  before(:each) do
    assign(:scheduled_events, [
      stub_model(ScheduledEvent,
        :repeat => 1,
        :mo => false,
        :tu => false,
        :we => false,
        :th => false,
        :fr => false,
        :sa => false,
        :su => false,
        :month_end => false,
        :month => 1,
        :month_day => 1
      ),
      stub_model(ScheduledEvent,
        :repeat => 1,
        :mo => false,
        :tu => false,
        :we => false,
        :th => false,
        :fr => false,
        :sa => false,
        :su => false,
        :month_end => false,
        :month => 1,
        :month_day => 1
      )
    ])
  end

  it "renders a list of scheduled_events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
