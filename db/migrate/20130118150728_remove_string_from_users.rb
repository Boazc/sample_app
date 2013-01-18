class RemoveStringFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :string
  end

  def down
  end
end
