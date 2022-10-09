module MagicNumber
  extend ActiveSupport::Concern

  included do
    before :cache, :check_magic_number!
  end

  private

  def check_magic_number!(new_file)
    return if version_name

    tmp_file = Pathname(new_file.file)
    content_type = Marcel::MimeType.for(tmp_file)
    return if content_type_allowlist.include?(content_type)

    raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.no_match_magic_number_error")
  end
end

