CarrierWave.configure do |config|
  config.storage = :aws
  # config.cache_storage = :file
  config.aws_bucket = Rails.application.credentials.dig(:aws, :bucket)
  config.aws_acl = 'private'

  config.aws_credentials = {
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: 'ap-northeast-1'
  }
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
