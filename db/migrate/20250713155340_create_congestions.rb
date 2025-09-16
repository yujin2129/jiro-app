class CreateCongestions < ActiveRecord::Migration[7.1]
  def change
    create_table :congestions do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :visited_on
      t.string :visited_time
      t.integer :level

      t.timestamps
    end
  end
end
