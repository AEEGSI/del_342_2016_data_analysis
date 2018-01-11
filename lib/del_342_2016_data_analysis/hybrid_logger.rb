require 'logger'

module Del3422016DataAnalysis
  class HybridLogger
    def initialize(log_file_path, skip_datetime: false)
      @logger = Logger.new(log_file_path)
      if skip_datetime
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
        end
      end
    end

    def info(message)
      @logger.info(message)
      puts message
    end

    def error(message)
      @logger.error(message)
      puts "!!#{message}"
    end
  end
end
