require 'spec_helper'

describe "scheduled_events/new.html.erb" do
  before(:each) do
    assign(:scheduled_event, stub_model(ScheduledEvent,
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
    ).as_new_record)
  end

  it "renders new scheduled_event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => scheduled_events_path, :method => "post" do
      assert_select "input#scheduled_event_repeat", :name => "scheduled_event[repeat]"
      assert_select "input#scheduled_event_mo", :name => "scheduled_event[mo]"
      assert_select "input#scheduled_event_tu", :name => "scheduled_event[tu]"
      assert_select "input#scheduled_event_we", :name => "scheduled_event[we]"
      assert_select "input#scheduled_event_th", :name => "scheduled_event[th]"
      assert_select "input#scheduled_event_fr", :name => "scheduled_event[fr]"
      assert_select "input#scheduled_event_sa", :name => "scheduled_event[sa]"
      assert_select "input#scheduled_event_su", :name => "scheduled_event[su]"
      assert_select "input#scheduled_event_month_end", :name => "scheduled_event[month_end]"
      assert_select "input#scheduled_event_month", :name => "scheduled_event[month]"
      assert_select "input#scheduled_event_month_day", :name => "scheduled_event[month_day]"
    end
  end
end
