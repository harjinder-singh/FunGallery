class CreateWardrobes < ActiveRecord::Migration
  def change
    create_table :wardrobes do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
