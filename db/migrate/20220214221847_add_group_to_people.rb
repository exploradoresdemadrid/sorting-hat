class AddGroupToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :group, :string
  end
end
