require 'fileutils'

module Del3422016DataAnalysis
  module IgnoreFile

    def self.path(base_path)
      File.join(Del3422016DataAnalysis::Folders.excel_path(base_path), "ignore.txt")
    end

    def self.touch(base_path)
      FileUtils.touch path(base_path)
    end

    # read the 'ignore.txt' file to get the list of operators to skip
    def self.read(base_path)
      files_to_ignore = []
      File.open(path(base_path), "r") do |f|
        f.each_line do |line|
          files_to_ignore << line.strip
        end
      end
      files_to_ignore
    end
  end
end
