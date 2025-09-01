class ChangeUserIdNullOnCongestions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :congestions, :user_id, true
  end
end
