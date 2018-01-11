require 'fileutils'

module Del3422016DataAnalysis
  module Folders
    def self.create_folders(path)
      puts "Creating folder structure at '#{path}'"
      FileUtils.mkdir_p excel_path(path)
      FileUtils.mkdir_p csv_path(path)
      FileUtils.mkdir_p log_path(path)
      FileUtils.mkdir_p dat_path(path)
      FileUtils.mkdir_p results_path(path)

      Del3422016DataAnalysis::IgnoreFile.touch(path)
    end

    def self.excel_path(path)
      File.join(path, "input-files", "excel")
    end

    def self.csv_path(path)
      File.join(path, "input-files", "csv")
    end

    def self.log_path(path)
      File.join(path, "log")
    end

    def self.dat_path(path)
      File.join(path, "dat-files")
    end

    def self.results_path(path)
      File.join(path, "results")
    end
  end
end
