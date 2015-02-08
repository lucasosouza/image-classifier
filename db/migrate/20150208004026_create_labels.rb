class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string  :category
      t.integer :rank
      t.float   :score
      t.integer :image_id

      t.timestamps
    end
  end
end
