class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :token
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
