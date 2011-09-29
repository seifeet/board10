class AddSchoolIdToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :school_id, :integer
  end
end
