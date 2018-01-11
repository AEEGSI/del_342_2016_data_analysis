module Del3422016DataAnalysis

  class DatDirs
    attr_reader :dat_path, :files_list
    # operators is an array of operator to keep
    def initialize(base_path, operators)
      @dat_path = Del3422016DataAnalysis::Folders.dat_path(base_path)

      dat_path = Dir.glob(File.join(@dat_path, "*"))
      dat_path.map!{|path| {path: path, operator: operator(path)}}
      dat_path.keep_if{|h| File.directory?(h[:path])}
      dat_path.keep_if{|h| operators.include?(h[:operator])}
      @dat_path = dat_path
    end

    def operator(path)
      File.basename(path).downcase
    end

    def size
      @dat_path.size
    end

    def each(&block)
      @dat_path.each{|f| yield(f)}
    end

  end

end
