module Del3422016DataAnalysis

  # --- julia executable
  JULIA_EXE = "/Applications/Julia-0.5.app/Contents/Resources/julia/bin/julia"
  # --- julia sources dir
  JULIA_SRC = File.expand_path(File.join("..","..","julia"), File.dirname(__FILE__))



  def run_julia(input_files_path, logger)
    logger.info "   ...running julia scripts..."

    main_src = File.join(JULIA_SRC, "main.jl")
    begin
      o, e, s = Open3.capture3("#{JULIA_EXE} #{main_src} #{JULIA_SRC} #{input_files_path}")
      logger.info o
      logger.error e
    rescue Exception => e
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
  end
end
