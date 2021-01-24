class CreateExecutions < ActiveRecord::Migration[6.1]
  def change
    create_table :executions, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.integer :iterations
      t.float :target_function
      t.float :progress, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
