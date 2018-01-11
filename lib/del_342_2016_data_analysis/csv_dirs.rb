module Del3422016DataAnalysis

  class CsvDirs
    attr_reader :csv_path, :files_list
    # operators is an array of operator to keep
    def initialize(base_path, operators)
      @csv_path = Del3422016DataAnalysis::Folders.csv_path(base_path)

      dirs_list = Dir.glob(File.join(@csv_path, "*"))
      dirs_list.map!{|path| {path: path, operator: operator(path)}}
      dirs_list.keep_if{|h| File.directory?(h[:path])}
      dirs_list.keep_if{|h| operators.include?(h[:operator])}
      @dirs_list = dirs_list
    end

    def operator(path)
      File.basename(path).downcase
    end

    def size
      @dirs_list.size
    end

    def each(&block)
      @dirs_list.each{|f| yield(f)}
    end

  end

end
