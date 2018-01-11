
module Del3422016DataAnalysis

  class ExcelFiles
    attr_reader :excel_path, :files_list
    # operators is an array of operator to keep
    def initialize(base_path, operators)
      @excel_path = Del3422016DataAnalysis::Folders.excel_path(base_path)

      files_list = Dir.glob(File.join(@excel_path, "*.xlsx"))
      files_list.map!{|path| {path: path, operator: operator(path)}}
      files_list.keep_if{|h| operators.include?(h[:operator])}
      @files_list = files_list
    end

    def operator(path)
      File.basename(path, ".xlsx").downcase
    end

    def size
      @files_list.size
    end

    def each(&block)
      @files_list.each{|f| yield(f)}
    end

  end

end
