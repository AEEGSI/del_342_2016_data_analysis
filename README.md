# Del. 342/2016 Data Analysis

Scripts used to read and analyse data provided by 'utenti del dispacciamento'.
Reference: https://www.autorita.energia.it/it/docs/16/342-16.htm

## Setup

In order to read Excel files and convert them to CSV format i use the Python library **xlsx2csv** (https://github.com/dilshod/xlsx2csv). None of similar Ruby libraries that i tried are so quick. Therefore you need to install Python.
The core calculations for the aims of resolution are executed using Julia algorithms but are not provided in this issue.

Works with `*.xlsx` (not `*.xls`) files.

## Preliminary steps

1. Run `ruby bin/create_folders.rb /some/path` in order to let script create the folders structure.
2. Move your Excel files (`*.xlsx`) inside `/some/path/input-files/excel` directory.
3. Eventually insert filenames you don't want to be processed into `/some/path/input-files/excel/ignore.txt` file.

## Steps of elaboration

1. **Convert**. To improve the reading speed of `.xslx` files, they will be converted to `.csv` files (one for each sheet) using the Python `xlsx2csv` library.
2. **Check**. The `.csv` files are read to check the correctness of values.
3. **Calculate**. The `.csv` files are now read and prepared for Julia algorithms.
4. **Reduce**. The results of the previous state are finally read and written in _n_ `.txt` (one for each operator) and one Excel file.

## Use

A command is provided to run one or more steps of data analysis.
```bash
usage: bin/run.rb [options] /path/to/data/folder
    -y, --year         starting year (mandatory)
    -o, --operators    operator names (default: ALL)
    -s, --steps        step names (default: ALL)
    -i, --interactive  enable interactive mode on selecting operators
    --help
```

### All steps

`bin/run.rb -y 2015 /path/to/data/folder` will execute all steps on all operators (except those specified inside `ignore.txt` file).

### All steps, interactive

`bin/run.rb -y 2015 /path/to/data/folder` same as previous, but at each step you will be prompted to proceed or not with the current operator.

### Some step

`bin/run.rb -y 2015 -s calculate,reduce /path/to/data/folder` will execute two steps (`calculate` and `reduce`) on all operators.

### Some operator

`bin/run.rb -y 2015 -o acme,energya /path/to/data/folder` will execute all steps on two operators (if not specified inside `ignore.txt` file).
