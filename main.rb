$APPLICATION_NAME = "RPGMaker VX Ace JSON Converter"
$VERSION = "1.0.0"

require_relative 'rgssV3/rpg'
require_relative 'miscV3'
require 'optparse'

# Map containing the default names of the folders
DEFAULT_FOLDERS = {
	data: "data",
	json: "ace_json",
	test_dir: "test"
}

def saveDataAsJson(fileName, jsonDir, data)
	Dir.mkdir(jsonDir) unless Dir.exist?(jsonDir)
	outPath = "#{jsonDir}/#{fileName}.json"
	puts "Saving JSON version of #{fileName} ..."
	save_data(data, outPath, true)
end

def updateDataFromJson(fileName, jsonDir, outDir, data)
	jsonPath = "#{jsonDir}/#{fileName}.json"
	return unless File.exist?(jsonPath)

	Dir.mkdir(outDir) unless Dir.exist?(outDir)

	puts "Updating #{fileName} from JSON version ..."
	jsonData = JSON.parse(File.read(jsonPath))
	if data.is_a?(Array)
		data.each_with_index do |d, i|
			next unless jsonData[i]
			next unless d
			d.updateFromJson(jsonData[i])
		end
	elsif data.is_a?(Hash)
		data.each do |k, v|
			next unless jsonData[k]
			next unless v
			v.updateFromJson(jsonData[k])
		end
	else
		data.updateFromJson(jsonData)
	end
	save_data(data, "#{outDir}/#{fileName}.rvdata2")
end

begin
	opts = OptionParser.new
	opts.banner = "Usage: ruby main.rb [options]"
	data_dir = nil
	out_dir = nil
	opts.on('-dDIR', '--data-dir DIR', 'Path to data directory (default: data)') { |d| data_dir = d }
	opts.on('-jDIR', '--json-dir DIR', 'Path to json directory (default: ace_json)') { |d| out_dir = d }
	opts.on('-h', '--help', 'Show this help') { puts opts; exit }
	opts.parse!(ARGV)

	if data_dir.nil?
		data_dir = DEFAULT_FOLDERS[:data]
		puts "Using default data directory: #{data_dir}"
	end

	if out_dir.nil?
		out_dir = DEFAULT_FOLDERS[:json]
		puts "Using default json directory: #{out_dir}"
	end

	initDataFiles(data_dir)

	$RPG_OBJECTS.each {|n, o| saveDataAsJson(n, out_dir, o) }
	$RPG_OBJECTS.each {|n, o| updateDataFromJson(n, out_dir, DEFAULT_FOLDERS[:test_dir], o) }

rescue => e
	puts "ERROR APPLICATION CRASHED WITH:"
	puts e.inspect
	puts e.backtrace.join("\n")
end

exitWithEnter
