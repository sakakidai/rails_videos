class VideoUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick
  include MagicNumber

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(mp4)
  end

  def content_type_allowlist
    %w[video/mp4]
  end

  def size_range
    0..1.gigabyte
  end
end
