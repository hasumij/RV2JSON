$APPLICATION_NAME = "RPGMaker VX Ace JSON Converter"
$VERSION = "1.0.0"

require_relative 'rgssV3/rpg'
require_relative 'miscV3'
require 'optparse'

def saveDataAsJson(fileName, outDir, data)
	Dir.mkdir(outDir) unless Dir.exist?(outDir)
	outPath = "#{outDir}/#{fileName}.json"
	puts "Saving JSON version of #{fileName} ..."
	save_data(data, outPath, true)
end

begin
	opts = OptionParser.new
	opts.banner = "Usage: ruby main.rb [options]"
	data_dir = nil
	out_dir = nil
	opts.on('-dDIR', '--data-dir DIR', 'Path to data directory (default: data)') { |d| data_dir = d }
	opts.on('-oDIR', '--output-dir DIR', 'Path to output directory (default: patch)') { |d| out_dir = d }
	opts.on('-h', '--help', 'Show this help') { puts opts; exit }
	opts.parse!(ARGV)

	if data_dir.nil?
		data_dir = "data"
		puts "Using default data directory: #{data_dir}"
	end

	if out_dir.nil?
		out_dir = "patch"
		puts "Using default output directory: #{out_dir}"
	end

	initDataFiles(data_dir)

	$RPG_OBJECTS.each {|n, o| saveDataAsJson(n, out_dir, o) }

rescue => e
	puts "ERROR APPLICATION CRASHED WITH:"
	puts e.inspect
	puts e.backtrace.join("\n")
end

exitWithEnter
