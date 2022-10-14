module VirusScan
  extend ActiveSupport::Concern

  included do
    before :cache, :scan_for_viruses!
  end

  private

  def scan_for_viruses!(new_file)
    return if version_name

    begin
      Clamby.safe?(new_file.file)
    rescue Clamby::ClamscanClientError => e
      raise ClamscanNotFoundError, I18n.translate(:"errors.messages.clamscan_client_error")
    rescue Clamby::ClamscanMissing => e
      raise ClamscanNotFoundError, I18n.translate(:"errors.messages.clamscan_missing_error")
    rescue Clamby::VirusDetected => e
      raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.clamscan_virus_detected_error")
    end
  end
end
