class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :icon
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
