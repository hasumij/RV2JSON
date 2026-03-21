$APPLICATION_NAME = "RPGMaker VX Ace JSON Converter - RV2JSON"
$VERSION = "1.1.0"

require_relative 'rgssV3/rpg'
require_relative 'miscV3'

require 'optparse'
require 'zlib'
require 'fileutils'

# TODOs:
# - Improve the printing

# Map containing the default names of the folders
DEFAULT_FOLDERS = {
	data: "data",
	json: "ace_json"
}

def createBackup(filePath, backupDir, verbose = false)
	backupPath = "#{backupDir}/#{File.basename(filePath)}"
	Dir.mkdir(backupDir) unless Dir.exist?(backupDir)

	if File.exist?(backupPath)
		puts "Backup already exists for #{filePath}, skipping backup creation." if verbose
	else
		FileUtils.cp(filePath, backupPath)
		puts "Created backup for #{filePath} in #{backupPath}"
	end
end

def saveDataAsJson(fileName, jsonDir, data, verbose = false)
	Dir.mkdir(jsonDir) unless Dir.exist?(jsonDir)
	outPath = "#{jsonDir}/#{fileName}.json"
	puts "Saving JSON version of #{fileName} ..." if verbose
	save_data(data, outPath, true)
end

def updateDataFromJson(fileName, jsonDir, outDir, data, verbose = false)
	jsonPath = "#{jsonDir}/#{fileName}.json"
	return unless File.exist?(jsonPath)

	Dir.mkdir(outDir) unless Dir.exist?(outDir)

	puts "Updating #{fileName} from JSON version ..." if verbose
	$CURRENT_FILE = jsonPath
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

def decodeScriptCode(c)
	s = Zlib::Inflate.inflate(c).force_encoding('UTF-8')
	return s
end

def encodeScriptCode(c)
	return Zlib::Deflate.deflate(c)
end

def writeScriptToFile(c, fileName)
	File.open(fileName, 'w') { |file| file.write(decodeScriptCode(c)) }
end

def readScriptFromFile(fileName)
	return encodeScriptCode(File.read(fileName))
end

def dumpScripts(scriptFile, outDir)
	# Create the dump directory in case it does not exist
	Dir.mkdir(outDir) unless Dir.exist?(outDir)

	# Load the Scripts file
	temp = load_data(scriptFile)

	if temp == nil
		puts "ERROR: Could not load scripts from #{scriptFile}"
		return
	end

	puts "Start dumping scripts..."

	cnt = 0

	temp.each do | script |
		idx = script[0]
		name = script[1]
		name.gsub!(/(\<|\>|\:|\"|\/|\\|\||\?|\*)/) {''}
		n = "#{outDir}/#{idx}_#{name}.rb"
		writeScriptToFile(script[2], n)
		cnt += 1
	end

	puts "Dumping of #{cnt} scripts done"
end

def updateScripts(scriptFile, dumpDir, outDir, skipBackup = false)
	if not Dir.exist?(dumpDir)
		puts "WARNING: Unable to update scripts. Directory #{dumpDir} does not exist."
		return
	end

	# Load the Scripts file
	temp = load_data(scriptFile)
	$CURRENT_FILE = nil

	if temp == nil
		puts "ERROR: Could not load scripts from #{scriptFile}"
		return
	end

	createBackup(scriptFile, "#{outDir}/backups") if outDir == File.dirname(scriptFile) && !skipBackup

	puts "Start updating scripts..."

	cnt = 0

	temp.each do | script |
		idx = script[0]
		name = script[1]
		name.gsub!(/(\<|\>|\:|\"|\/|\\|\||\?|\*)/) {''}
		n = "#{dumpDir}/#{idx}_#{name}.rb"
		if File.exist?(n)
			script[2] = readScriptFromFile(n)
			cnt += 1
		end
	end

	save_data(temp, "#{outDir}/Scripts.rvdata2")

	puts "Updating of #{cnt} scripts done"
end

def dumpFiles(dataDir, outDir)
	$CURRENT_FILE = nil
	$RPG_OBJECTS.each {|n, o| saveDataAsJson(n, outDir, o) }
	$CURRENT_FILE = nil

	# Dump scripts
	scriptDumpDir = "#{outDir}/scripts"
	scriptFile = "#{dataDir}/Scripts.rvdata2"
	dumpScripts(scriptFile, scriptDumpDir)
end

def updateFiles(dataDir, jsonDir, outDir, skipBackup = false, verbose = false)
	backupDir = "#{outDir}/backups"

	# Update data from JSON and save to test directory
	$RPG_OBJECTS.each do |n, o|
		# When performing an in-place update (dataDir == outDir), create a backup of the original file before overwriting it
		createBackup("#{dataDir}/#{n}.rvdata2", backupDir) if dataDir == outDir && !skipBackup
		updateDataFromJson(n, jsonDir, outDir, o, verbose)
	end

	# Update scripts from dumped versions and save to test directory
	scriptDumpDir = "#{jsonDir}/scripts"
	scriptFile = "#{dataDir}/Scripts.rvdata2"
	updateScripts(scriptFile, scriptDumpDir, outDir, skipBackup)
end
begin
	opts = OptionParser.new
	banner = <<EOF

██████╗ ██╗   ██╗██████╗      ██╗███████╗ ██████╗ ███╗   ██╗
██╔══██╗██║   ██║╚════██╗     ██║██╔════╝██╔═══██╗████╗  ██║
██████╔╝██║   ██║ █████╔╝     ██║███████╗██║   ██║██╔██╗ ██║
██╔══██╗╚██╗ ██╔╝██╔═══╝ ██   ██║╚════██║██║   ██║██║╚██╗██║
██║  ██║ ╚████╔╝ ███████╗╚█████╔╝███████║╚██████╔╝██║ ╚████║
╚═╝  ╚═╝  ╚═══╝  ╚══════╝ ╚════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝

EOF

	banner += "Usage: RV2JSON.exe ACTION [dir_options]"

	opts.banner = banner
	dataDir = nil
	jsonDir = nil
	outputDir = nil
	createFlag = false
	updateFlag = false
	skipBackup = false
	verbose = false

	opts.separator "Actions:"
	opts.on('-c', '--create', 'Create JSON dumps (calls dumpFiles)') { createFlag = true }
	opts.on('-u', '--update', 'Update data from JSON (calls updateFiles)') { updateFlag = true }
	opts.separator ""
	opts.separator "Directory options:"
	opts.on('-dDIR', '--data-dir DIR', 'Path to data directory (default: data)') { |d| dataDir = d }
	opts.on('-jDIR', '--json-dir DIR', 'Path to the json directory.', 'During create the JSON files will be created here.', 'During update they will be read from here. (default: ace_json)') { |d| jsonDir = d }
	opts.on('-oDIR', '--out-dir DIR', 'Path to output directory.', 'Used to store the updated rvdata2 files.', 'If not specified, the data directory (-d, --data-dir) will be used.') { |d| outputDir = d }
	opts.separator ""
	opts.separator "Other options:"
	opts.on('-s', '--skip-backup', 'When updating in-place (data dir == output dir),', 'skip creating a backup of the original files.', 'Use with caution.') { skipBackup = true }
	opts.on('-v', '--verbose', 'Print additional information during execution.') { verbose = true }
	opts.on('-h', '--help', 'Show this help') { puts opts; exit }
	opts.parse!(ARGV)

	# Make sure at least one action is requested
	if !createFlag && !updateFlag
		puts "ERROR: No action specified. Use -c to create JSON dumps or -u to update from JSON"
		puts "Use -h for extended help"
		exit 1
	end

	if dataDir.nil?
		dataDir = DEFAULT_FOLDERS[:data]
		puts "Using default data directory: #{dataDir}"
	end

	if jsonDir.nil?
		jsonDir = DEFAULT_FOLDERS[:json]
		puts "Using default json directory: #{jsonDir}"
	end

	if outputDir.nil?
		outputDir = dataDir
		puts "Using default output directory (data dir): #{outputDir}"
	end

	initDataFiles(dataDir, verbose)

	# Execute requested actions
	if createFlag
		puts "Running create (dumpFiles) -> json: #{jsonDir}"
		dumpFiles(dataDir, jsonDir)
	end

	if updateFlag
		puts "Running update (updateFiles) -> json: #{jsonDir}, output: #{outputDir}"
		updateFiles(dataDir, jsonDir, outputDir, skipBackup, verbose)
	end
rescue => e
	puts "ERROR APPLICATION CRASHED WITH:"
	puts e.inspect
	puts e.backtrace.join("\n")
	puts "Crash occurred while processing file: #{$CURRENT_FILE}" if $CURRENT_FILE
	exit 1
end

# exitWithEnter
