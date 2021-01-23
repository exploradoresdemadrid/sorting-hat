class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.string :name

      t.timestamps
    end
  end
end
