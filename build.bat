@echo off
SET OUTPUT_DIR=bin
REM Create the output directory if it doesn't exist
if not exist "%OUTPUT_DIR%" (
	mkdir "%OUTPUT_DIR%"
)

ocran RV2JSON.rb --output "%OUTPUT_DIR%/RV2JSON.exe" --icon rv2json.ico