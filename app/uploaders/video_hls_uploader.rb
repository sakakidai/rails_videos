class VideoHlsUploader < CarrierWave::Uploader::Base
  configure do |config|
    config.aws_authenticated_url_expiration = 60 * 60 * 24
  end

  def intiialize(index_model = nil, index_mounted_as = nil)
    @model = index_model
    @mounted_as = index_mounted_as
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
