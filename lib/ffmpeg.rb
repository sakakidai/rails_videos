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
      @command = ['ffprobe', '-i', file, *%w(-print_format json -show_format -show_streams -show_error)]
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

  class Transcoder
    attr_reader :command, :input, :hls_time, :hls_segment_filename, :output_index_file

    def initialize(input, specific_output_dir = nil)
      @input = input
      @hls_time = '10'
      file_name = ext_less_file_name
      output_dir = specific_output_dir || output_dir
      @hls_segment_filename = "#{output_dir}/#{file_name}%3d.ts"
      @output_index_file = "#{output_dir}/#{file_name}.m3u8"
    end

    def ext_less_file_name
      File.basename(input, '.*')
    end

    def output_dir
      File.dirname(input)
    end

    def transcode_hls
      options = %W(-vcodec copy -acodec copy -f hls -hls_time #{hls_time} -hls_playlist_type vod -hls_segment_filename #{hls_segment_filename})
      command = ['ffmpeg', '-i', input, *options, output_index_file]
      stdin, _, stderr, wait_thr = Open3.popen3(*command)
      begin
        if !wait_thr.value.success?
          std_error = stderr.read
          raise FFmpegError, "[failed command] #{command} [message] #{std_error}"
        end
      ensure
        stdin.close
      end
    end
  end
end
