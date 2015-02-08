class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :file_name
      t.string :address
      t.string :category

      t.timestamps
    end
  end
end
