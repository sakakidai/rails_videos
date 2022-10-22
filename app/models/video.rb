require('ffmpeg')
class Video < ApplicationRecord
  mount_uploader :video, VideoUploader
  mount_uploader :thumbnail, VideothumbnailUploader
  validates :title, presence: true

  def build_hls_files
    ffmpeg = FFmpeg::Video.new(video)
    ffmpeg.transcode_hls
    ffmpeg.delete_cache_dir
  end
end
