require 'spec_helper'

describe "messages/edit.html.erb" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :from_user => 1,
      :to_user => 1,
      :subject => "MyString",
      :content => "MyText",
      :type => 1,
      :state => 1
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => messages_path(@message), :method => "post" do
      assert_select "input#message_from_user", :name => "message[from_user]"
      assert_select "input#message_to_user", :name => "message[to_user]"
      assert_select "input#message_subject", :name => "message[subject]"
      assert_select "textarea#message_content", :name => "message[content]"
      assert_select "input#message_type", :name => "message[type]"
      assert_select "input#message_state", :name => "message[state]"
    end
  end
end
