# == Schema Information
#
# Table name: groups
#
#  id           :integer(4)      not null, primary key
#  title        :string(255)     not null
#  description  :text
#  view_count   :integer(4)      default(0)
#  active       :boolean(1)      default(TRUE)
#  access_level :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Group do
  pending "add some examples to (or delete) #{__FILE__}"
end
