class AddHolidayToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :holiday, :string
  end
end
