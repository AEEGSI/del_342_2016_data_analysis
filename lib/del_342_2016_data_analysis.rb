require 'date'
require 'csv'
# require 'byebug'
require 'pp'
require 'ostruct'
require 'open3'


require "del_342_2016_data_analysis/version"
require "del_342_2016_data_analysis/array"
require "del_342_2016_data_analysis/folders"
require "del_342_2016_data_analysis/ignore_file"
require "del_342_2016_data_analysis/operators"
require "del_342_2016_data_analysis/steps"
require "del_342_2016_data_analysis/interact"
require "del_342_2016_data_analysis/excel_files"
require "del_342_2016_data_analysis/hybrid_logger"
require "del_342_2016_data_analysis/csv_dirs"
require "del_342_2016_data_analysis/data_check"
require "del_342_2016_data_analysis/validate_values"
require "del_342_2016_data_analysis/sheet_row"
require "del_342_2016_data_analysis/sheet_1"
require "del_342_2016_data_analysis/sheet_2"
require "del_342_2016_data_analysis/sheet_3"
require "del_342_2016_data_analysis/sheet_456"
require "del_342_2016_data_analysis/exceptions"
require "del_342_2016_data_analysis/error_aggregator"
require "del_342_2016_data_analysis/julia"
require "del_342_2016_data_analysis/calculate"

module Del3422016DataAnalysis
  # Your code goes here...
end

include Del3422016DataAnalysis
