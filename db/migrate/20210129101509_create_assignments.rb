class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments, id: :uuid do |t|
      t.references :execution, null: false, foreign_key: true, type: :uuid
      t.references :preference, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
