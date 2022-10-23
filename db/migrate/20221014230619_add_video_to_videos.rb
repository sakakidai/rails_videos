class AddVideoToVideos < ActiveRecord::Migration[7.0]
  def up
    add_column :videos, :video, :string
    add_column :videos, :video_hls, :string
  end

  def down
    remove_column :videos, :video
    remove_column :videos, :video_hls
  end
end
