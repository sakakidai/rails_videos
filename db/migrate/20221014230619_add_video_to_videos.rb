class AddVideoToVideos < ActiveRecord::Migration[7.0]
  def up
    add_column :videos, :video, :string
  end

  def down
    remove_column :videos, :video
  end
end
