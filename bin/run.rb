require 'slop'
require "bundler/setup"
require "del_342_2016_data_analysis"

# ruby bin/run.rb
#   -y 2015
#   -o --operator Acme
#   -s --step convert
#   -i --interactive
#   /path/to/data/folder

# ruby bin/run.rb -y 2015 -o Acme,Eftza -s foo,bar -i boo/far
# ruby bin/run.rb --folders ~/bau

opts = Slop.parse do |o|
  o.integer '-y', '--year', 'starting year', required: true
  o.array   '-o', '--operators', 'operator names', delimiter: ',', default: ["ALL"]
  o.array   '-s', '--steps', 'step names', delimiter: ',', default: ["ALL"]
  o.bool    '-i', '--interactive', 'enable interactive mode on selecting operators', default: false
  o.bool    '-x', '--exit', 'exit on error', default: false
end


# --- steps
steps = Steps.new(opts[:steps])


# --- path
base_path = opts.arguments.shift


# --- operators
xlsx_to_ignore = Del3422016DataAnalysis::IgnoreFile.read(base_path)
# ruby bin/run.rb -y 2015 -o ALL /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb

interactive = opts.interactive?
# operators = opts[:operators].sort
operators = Operators.new(opts[:operators], xlsx_to_ignore)
# operators = :all if operators==["ALL"]
interactive = false if !operators.all?
excel_path = Del3422016DataAnalysis::Folders.excel_path(base_path)
if operators.all?
  operators.include(Dir.glob(File.join(excel_path, "*.xlsx")))
else
  # if will be passed a list of operators the interactive mode is disabled
  interactive = false
end


# puts operators.inspect
# #<Del3422016DataAnalysis::Operators:0x007fe537220ac8
#    @suffix=".xlsx",
#    @all=true,
#    @included=["duferco", "green_network", "green_network_luce_gas"],
#    @ignored=["acme"]>

raise "The folder you passed is not existing" if !Dir.exists?(base_path)


# logger
logger = HybridLogger.new(File.join(Del3422016DataAnalysis::Folders.excel_path(base_path), "check_sums.log"), skip_datetime: true)
logger.info "\n\n\nStart a new run!"



steps.each do |step|
  case step
  # ruby bin/run.rb -y 2015 -o ALL -s convert -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "convert"
    logger.info "\nConvert xlsx to csv..."
    intrv = interactive
    excel_files = ExcelFiles.new(base_path, operators)
    logger.info "   found #{excel_files.size} files\n"
    excel_files.each do |excel_file|
      op = excel_file[:operator]
      proceed = true
      proceed, intrv = ask_for(op) if intrv
      if proceed
        logger.info "  converting #{op}..."
        dest_path = File.join(Del3422016DataAnalysis::Folders.csv_path(base_path), op)
        `xlsx2csv -a #{excel_file.gsub(' ', '\ ')} #{dest_path.gsub(' ', '\ ')}` # http://blog.bigbinary.com/2012/10/18/backtick-system-exec-in-ruby.html
      end
    end

  # ruby bin/run.rb -y 2015 -o ALL -s check -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "check"
    logger.info "\nCheck correctness of data..."
    intrv = interactive
    csv_dirs = CsvDirs.new(base_path, operators)
    logger.info "   found #{csv_dirs.size} files\n\n"

    csv_dirs.each do |dir|
      proceed = true
      proceed, intrv = ask_for(dir[:operator]) if intrv
      if proceed
        check_data(dir[:path], dir[:operator], logger) # see data_check.rb
        logger.info "\n"
      end
    end

  # ruby bin/run.rb -y 2015 -o ALL -s calculate -i /Users/iwan/dev/ruby/del_342_2016_data_analysis/data/2013-pdb
  when "calculate"
    logger.info "\nStarting calculation..."
    intrv = interactive
    csv_dirs = CsvDirs.new(base_path, operators)
    logger.info "   found #{csv_dirs.size} operators\n\n"

    csv_dirs.each do |dir|
      proceed = true
      proceed, intrv = ask_for(dir[:operator]) if intrv
      if proceed
        calculate(dir, base_path, logger)
        logger.info "\n"
      end
    end


  when "reduce"
    # do something
  end

end

logger.info "\n\n\Finished.\n"



# opts = Slop.parse do |o|
#   o.string '-h', '--host', 'a hostname'
#   o.integer '--port', 'custom port', default: 80
#   o.string '-l', '--login', required: true
#   o.bool '-v', '--verbose', 'enable verbose mode'
#   o.bool '-q', '--quiet', 'suppress output (quiet mode)'
#   o.bool '-c', '--check-ssl-certificate', 'check SSL certificate for host'
#   o.on '--version', 'print the version' do
#     puts Slop::VERSION
#     exit
#   end
# end

# puts ARGV #=> -v --login alice --host 192.168.0.1 --check-ssl-certificate

# opts[:host]                 #=> 192.168.0.1
# opts[:login]                #=> alice
# opts.verbose?               #=> true
# opts.quiet?                 #=> false
# opts.check_ssl_certificate? #=> true

# puts opts.to_hash  #=> { host: "192.168.0.1", login: "alice", port: 80, verbose: true, quiet: false, check_ssl_certificate: true }
# puts opts.arguments.inspect

# base_path = opts.arguments.first


# puts steps.inspect
