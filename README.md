# Del. 342/2016 Data Analysis

Scripts used to read and analyse data provided by 'utenti del dispacciamento'.
Reference: https://www.autorita.energia.it/it/docs/16/342-16.htm

**Required**: to read xslx files and convert them to csv format i use the Python library (https://github.com/dilshod/xlsx2csv). None of similar Ruby libraries that i tried are so quick.
So you need to install Python.
The core calculations for the aims of resolution are executed using Julia algorithms but are not provided in this issue.


Works on xlsx files.

**Preliminary steps**

Run `ruby bin/create_folders.rb /some/path` in order to let script create the folders structure.

Move your Excel files (`*.xlsx`) into `/some/path/input-files/excel` directory.
Eventually insert filenames you don't want to be processed to the `/some/path/input-files/excel/ignore.txt` file.

**Steps of elaboration**

1. Convert. To improve the reading speed of `.xslx` files, they will be converted to `.csv` files (one for each sheet) using the Python `xlsx2csv` library.
2. Check. The `.csv` files are read to check the correctness of values.
3. Calculate. The `.csv` files are now read and prepared for Julia algorithms.
4. Reduce. The results of the previous state are finally read and written in _n_ `.txt` (one for each operator) and one Excel file.
