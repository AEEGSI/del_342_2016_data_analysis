# Del. 342/2016 Data Analysis

Scripts used to read and analyse data provided by 'utenti del dispacciamento'.
Reference: https://www.autorita.energia.it/it/docs/16/342-16.htm

**Required**: to read xslx files and convert them to csv format i use the Python library (https://github.com/dilshod/xlsx2csv). None of similar Ruby libraries that i tried are so quick.
So you need to install Python.
The core calculations for the aims of resolution are executed using Julia algorithms but are not provided in this issue.


works on xlsx files

Steps:
1. Create the folder structure. Run `ruby bin/create_folders.rb /some/path`.




Steps:
1. Set the `config.rb` file
2. Ensure you have the correct folder hierarchy. Use `create_folder_structure.rb`
3. Convert xlsx files to csv format using `convert_input_xlsx_to_csv.rb`
4. Check the correctness of data using `check_correctness.rb`
5. Convert data and run Julia functions using `read_csv_files.rb`
6. Collect results and put them into an Excel file using `read_and_compact_disp_dat.rb`
