class CreatePreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :preferences, id: :uuid do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :session, null: false, foreign_key: true, type: :uuid
      t.integer :value

      t.timestamps
    end
  end
end
