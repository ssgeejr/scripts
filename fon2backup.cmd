@echo off
setlocal enabledelayedexpansion

:: Change directory to the target folder
cd /d "C:\Users\geest\AppData\Roaming\AY std\Force Of Nature 2\Worlds"

:: Set variables
set folder_to_compress=w000
set base_name=MyArchive
set extension=.7z
set counter=1
set output_file=%base_name%%extension%

:: Check if the file exists and increment the counter
:check_file
if exist "%output_file%" (
    set /a counter+=1
    set output_file=%base_name%_%counter%%extension%
    goto :check_file
)

:: Compress the folder using the full path to 7-Zip
"C:\Program Files\7-Zip\7z.exe" a "%output_file%" "%folder_to_compress%"

:: Display the result
echo Backup created: %output_file%
