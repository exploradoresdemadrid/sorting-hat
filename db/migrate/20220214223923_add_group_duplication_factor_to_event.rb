class AddGroupDuplicationFactorToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :group_duplication_factor, :float, default: 0
  end
end
