CarrierWave.configure do |config|
  config.storage = :aws
  config.aws_bucket = Rails.application.credentials.dig(:aws, :bucket)
  config.aws_acl = 'private'

  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  config.aws_credentials = {
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: 'ap-northeast-1'
  }
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
