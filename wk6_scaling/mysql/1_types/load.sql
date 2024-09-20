-- Demonstrates loading data from a CSV file

-- Load a CSV of riders into the riders table
LOAD DATA 
    INFILE 'red.csv'
    INTO TABLE `stations`
    FIELDS
        TERMINATED BY ','
        ENCLOSED BY '"'
    LINES
        TERMINATED BY '\n'
    IGNORE 1 ROWS;
-- "LOAD DATA (LOCAL) INFILE '<file>'" imports data from an on-premises file. All text files are supported.
-- "LOCAL" indicates that the file is read from the client host. If "LOCAL" is not specified, the file must be located on the server.
-- "INTO TABLE `<table>`"" intserts the data into the table.
-- "TERMINATED BY" specifies what character is used as the delimiter.
-- "ENCLOSED BY" specifies what character will be removed from the beginning and end of field values if it exists.
-- "IGNORE 1 ROWS" ignores the first row in csv file.
-- For a text file generated on a Windows system, proper file reading might require LINES TERMINATED BY '\r\n'
-- because Windows programs typically use '\r\n' as a line terminator.
-- And some programs, might use '\r' as a line terminator when writing files.
-- In Windows:
--     \r (Carriage Return): moves the cursor to the beginning of the line without advancing to the next line.
--     \n (Line Feed): moves the cursor down to the next line without returning to the beginning of the line.
--     \r\n (End Of Line): a combination of \r and \n.