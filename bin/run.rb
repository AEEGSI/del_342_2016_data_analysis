require 'slop'
require "bundler/setup"
require "del_342_2016_data_analysis"

# ruby bin/run.rb
#   -y 2015
#   -o --operator Acme
#   -s --step convert
#   -i --interactive
#   /path/to/data/folder

# ruby bin/run.rb -y 2013 -o Acme,Eftza -s calculate,reduce -i boo/far
# ruby bin/run.rb -y 2013 -o ALL -s ALL -i boo/far
# ruby bin/run.rb -y 2013 -o ALL -s ALL boo/far

opts = Slop.parse do |o|
  o.banner = "#{o.banner} /path/to/data/folder"
  o.integer '-y', '--year', 'starting year (mandatory)', required: true
  o.array   '-o', '--operators', 'operator names (default: ALL)', delimiter: ',', default: ["ALL"]
  o.array   '-s', '--steps', 'step names (default: ALL)', delimiter: ',', default: ["ALL"]
  o.bool    '-i', '--interactive', 'enable interactive mode on selecting operators', default: false
  # o.bool    '-x', '--exit', 'exit on error', default: false
  o.on '--help' do
    puts o
    exit
  end
end

# --- year
year = opts[:year]

# --- steps
steps = Steps.new(opts[:steps])

# --- path
base_path = opts.arguments.shift


# --- operators
xlsx_to_ignore = Del3422016DataAnalysis::IgnoreFile.read(base_path)
# ruby bin/run.rb -y 2015 -o ALL /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb

interactive = opts.interactive?
operators = Operators.new(opts[:operators], xlsx_to_ignore)
interactive = false if !operators.all?
excel_path = Del3422016DataAnalysis::Folders.excel_path(base_path)
if operators.all?
  operators.include(Dir.glob(File.join(excel_path, "*.xlsx")))
else
  # if will be passed a list of operators the interactive mode is disabled
  interactive = false
end


raise "The folder you passed is not existing" if !Dir.exists?(base_path)

# --- logger
logger = HybridLogger.new(File.join(Del3422016DataAnalysis::Folders.log_path(base_path), "logger.log"), skip_datetime: true)
logger.info "\n\nStart a new run!"



steps.each do |step|
  case step
  # ruby bin/run.rb -y 2013 -o ALL -s convert -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "convert"
    logger.info "\nConvert xlsx to csv..."
    intrv = interactive
    excel_files = ExcelFiles.new(base_path, operators)
    logger.info "   found #{excel_files.size} files\n"
    excel_files.each do |excel_file|
      op = excel_file[:operator]
      proceed = true
      proceed, intrv = ask_for(op, "convert xlsx to csv") if intrv
      if proceed
        logger.info "  converting #{op}..."
        dest_path = File.join(Del3422016DataAnalysis::Folders.csv_path(base_path), op)
        `xlsx2csv -a #{excel_file[:path].gsub(' ', '\ ')} #{dest_path.gsub(' ', '\ ')}` # http://blog.bigbinary.com/2012/10/18/backtick-system-exec-in-ruby.html
      end
    end

  # ruby bin/run.rb -y 2013 -o ALL -s check -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "check"
    logger.info "\nCheck correctness of data..."
    intrv = interactive
    csv_dirs = CsvDirs.new(base_path, operators)
    logger.info "   found #{csv_dirs.size} files\n\n"

    csv_dirs.each do |dir|
      proceed = true
      proceed, intrv = ask_for(dir[:operator], "check data integrity") if intrv
      if proceed
        check_data(dir[:path], dir[:operator], logger) # see data_check.rb
        logger.info "\n"
      end
    end

  # ruby bin/run.rb -y 2013 -o ALL -s calculate -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "calculate"
    logger.info "\nStarting calculation..."
    intrv = interactive
    csv_dirs = CsvDirs.new(base_path, operators)
    logger.info "   found #{csv_dirs.size} operators\n\n"

    csv_dirs.each do |dir|
      proceed = true
      proceed, intrv = ask_for(dir[:operator], "run calculations") if intrv
      if proceed
        calculate(dir, base_path, logger)
        logger.info "\n"
      end
    end

    # ruby bin/run.rb -y 2013 -o ALL -s reduce -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "reduce"
    logger.info "\nStarting reduction..."
    intrv = interactive
    dat_dirs = DatDirs.new(base_path, operators)
    logger.info "   found #{dat_dirs.size} operators\n\n"
    reduce(dat_dirs, base_path, year, logger)
  end

end

logger.info "\n\n\Finished.\n"
