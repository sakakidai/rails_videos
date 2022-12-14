require('open3')

module FFmpeg
  class FFmpegError < StandardError; end

  # DEFAULT_CONFIG = {}

  # @config = DEFAULT_CONFIG.dup


  # class << self
  #   attr_reader :config
  # end

  class Video
    attr_accessor :uploader, :index_file, :cache_dir, :segment_files

    def initialize(uploader)
      @uploader = uploader
      @cache_dir = build_cache_dir
      @segment_files = []
    end

    def delete_cache_dir
      FileUtils.rm_r(cache_dir)
    end

    def transcode_hls
      ffmpeg = FFmpeg::Transcoder.new(uploader.url, cache_dir)
      if ffmpeg.transcode_hls
        self.index_file = ffmpeg.output_index_file
        self.segment_files = Dir.entries(cache_dir).grep(/\A#{ffmpeg.file_name}\d+.ts/).map {|segment| "#{cache_dir}/#{segment}"}
      end
    end

    private

    def build_cache_dir
      FileUtils.mkdir_p("public/ffmpegs/cache/#{uploader.model.class.to_s.underscore}/#{uploader.model.id}")[0]
    end
  end

  class Outptter
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def fetch_metadata
      command = ['ffprobe', '-i', file, *%w(-print_format json -show_format -show_streams -show_error)]
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
    attr_reader :input, :file_name, :hls_time, :hls_segment_filename, :output_index_file

    def initialize(input, specific_output_dir = nil)
      @input = input
      @hls_time = '10'
      @file_name = ext_less_file_name
      output_dir = specific_output_dir || input_dirname
      @hls_segment_filename = "#{output_dir}/#{file_name}%3d.ts"
      @output_index_file = "#{output_dir}/#{file_name}.m3u8"
    end

    def transcode_hls
      options = %W(-vcodec copy -acodec copy -f hls -hls_time #{hls_time} -hls_playlist_type vod -hls_segment_filename #{hls_segment_filename})
      command = ['ffmpeg', '-i', input, *options, output_index_file]
      stdin, _, stderr, wait_thr = Open3.popen3(*command)
      begin
        if wait_thr.value.success?
          return true
        else
          std_error = stderr.read
          raise FFmpegError, "[failed command] #{command} [message] #{std_error}"
        end
      ensure
        stdin.close
      end
    end

    private

    def ext_less_file_name
      File.basename(input, '.*')
    end

    def input_dirname
      File.dirname(input)
    end
  end
end
