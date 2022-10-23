require('ffmpeg')
class Video < ApplicationRecord
  mount_uploader :video, VideoUploader
  mount_uploader :video_hls, VideoHlsUploader
  mount_uploader :thumbnail, VideothumbnailUploader
  validates :title, presence: true

  def upload_hls_files
    ffmpeg = FFmpeg::Video.new(video)
    ffmpeg.transcode_hls
    File.open(ffmpeg.index_file, 'r') do |f|
      self.video_hls = f
      if self.save!
        upload_segment_files(ffmpeg.segment_files)
      end
    end
    ffmpeg.delete_cache_dir
  end

  def upload_segment_files(segment_files)
    segment_files.each do |segment_file|
      File.open(segment_file, 'r') do |f|
        VideoHlsUploader.new(self, self.video_hls.mounted_as.to_s).store!(f)
      end
    end
  end
end
