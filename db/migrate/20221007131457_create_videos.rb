class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :content
      t.string :thumbnail

      t.timestamps
    end
  end
end
