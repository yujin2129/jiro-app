class AddMenuToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :menu, :text
  end
end
