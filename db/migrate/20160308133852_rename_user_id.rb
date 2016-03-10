class RenameUserId < ActiveRecord::Migration
  def change
    remove_column :events, :user_id
    add_column :events, :author_id, :integer
  end
end
