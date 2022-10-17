require('open3')

module FFmpeg
  class FFmpegError < StandardError; end

  # DEFAULT_CONFIG = {}

  # @config = DEFAULT_CONFIG.dup


  # class << self
  #   attr_reader :config
  # end

  class Outptter
    attr_reader :command, :file

    def initialize(file)
      @command = ['ffmpeg', '-i', file, *%w(-print_format json -show_format -show_streams -show_error)]
    end

    def fetch_metadata
      stdin, stdout, stderr, wait_thr = Open3.popen3(*command)
      begin
        if wait_thr.value.success?
          std_output = stdout.read
        else
          std_error = stderr.read
          raise FFmpegError, "[failed command] #{command} [message] #{std_error}"
        end
      ensure
        stdin.close
      end
      JSON.parse(std_output, symbolize_names: true)
    end
  end

  # class Transcoder
  #   attr_reader :command, :input

  #   def initialize(command, input)
  #     @command = ['ffmpeg', 'i', input]
  #   end
  # end
end
