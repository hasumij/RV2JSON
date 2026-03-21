require_relative 'rgssV3/rpg'

def exitWithEnter
	puts "Press enter to exit..."
	$stdin.gets.chomp
	exit
end

def sanitizePath(path)
	sanitizedPath = path.strip
	sanitizedPath.gsub!(/(\<|\>|\"|\||\?|\*)/) {''}

	return sanitizedPath
end

def sanitizeFilename(fileName)
	sanitizedName = fileName.strip
	sanitizedName.gsub!(/(\<|\>|\:|\"|\/|\\|\||\?|\*)/) {''}
	# Repace new lines with underscores
	sanitizedName.gsub!(/\r\n|\r|\n/) { "_" }

	# Strip out the non-ascii character
	# sanitizedName.gsub!(/[^0-9A-Za-z.\-]/, '_')

	return sanitizedName
end

# TODO: Maybe move this to rpg.rb - overall restructure and clean up
$ENGINE = nil
$ENGINE_EXT = nil

def detectEngine(dataDir)
	return if $ENGINE

	$ENGINE = :vxace unless Dir["#{dataDir}/*#{ENGINES[:vxace]}"].empty?
	$ENGINE = :vx    unless Dir["#{dataDir}/*#{ENGINES[:vx]}"].empty?
	$ENGINE = :mv    unless Dir["#{dataDir}/*#{ENGINES[:mv]}"].empty?

	if $ENGINE
		puts "Detected Engine: #{$ENGINE}"
		$ENGINE_EXT = ENGINES[$ENGINE]
	else
		puts "Unable to detect game engine"
		exitWithEnter
	end
end

def isMV?
	return $ENGINE == :mv
end

def checkDataDirExists(dataDir)
	if !Dir.exist?(dataDir)
		puts "Data directory \"#{dataDir}\" does not exists exiting ..."
		exitWithEnter
	end
	detectEngine(dataDir)
end

def checkPatchDirExists(dataDir)
	if !Dir.exist?(dataDir)
		puts "Patch directory \"#{dataDir}\" does not exists exiting ..."
		exitWithEnter
	end
end

def getAllFiles(folder = ".")
	# Get all files (with an extension) in this and all sub directories
	files = Dir.glob("#{folder}/**/*.*")

	return files
end

def getAllNonAsciiFiles(folder = ".")
	files = getAllFiles(folder)

	# Remove all elements containing only ascii characters
	# Use basename to ignore folder names
	files.reject!{ |f| File.basename(f, ".*").ascii_only? }
	return files
end

def getAllNonAsciiFileNames(folder = ".")
	files = getAllNonAsciiFiles(folder)

	# Only retain the filename
	files.map!{ |f|	File.basename(f, ".*") }

	return files
end

def getAllFileNames(folder = ".")
	files =  getAllFiles(folder)

	files.map!{ |f| File.basename(f, ".*") }

	return files
end

def loadFileAndPrintHeader(file, task, print = true)
	fN = file + $ENGINE_EXT

	if !File.exist?(fN)
		puts "Data file \"#{fN}\" does not exist, skipping ..."
		return nil
	end

	puts "#{task} #{File.basename(fN, ".*")}" unless !print
	return load_data("#{fN}")
end

def loadFile(fileName, print = true)
	return loadFileAndPrintHeader(fileName, "Loading", print)
end

def validateFile(dataDir, fN)
	org = File.open("#{dataDir}/#{fN}.json", "r:UTF-8") { |f| JSON.parse(f.read) }
	cmpObj = loadFile("#{dataDir}/#{fN}", false)
	# MapInfo is stored as a hash, therefore, this is required to properly generate the output json
	cmpObj = cmpObj.values if cmpObj.class == Hash
	cmp = JSON.parse(cmpObj.to_json)

	unless cmp == org
		puts "Failed to recreate json file for: #{fN}"
		return false
	end

	return true
end

# Checks if the MV classes manage to correctly recreate the original json files,
# to ensure that no fields are removed or added during potential modifications
def validateRecreation(dataDir, dataFiles)
	return unless $ENGINE == :mv
	puts "Checking if parser is able to recreate the original json files without problems ..."
	success = true
	dataFiles.each { |fN| success &= validateFile(dataDir, fN) }

	if success
		puts "All files were successfully recreated, no problems should occure"
	else
		puts "Unable to recreate the json file for one or more files, this could cause problems"
		exitWithEnter
	end
end

def initDataFiles(dataDir, verbose = true, check = true)
	checkDataDirExists(dataDir)

	dataFiles = ["CommonEvents", "System", "MapInfos", "Actors", "Animations", "Armors", "Classes", "Enemies", "Items", "Skills", "States", "Tilesets", "Troops", "Weapons"]
	dataFiles << Dir.entries(dataDir).grep(/Map\d\d\d/).map{|f| File.basename(f, ".*")}
	dataFiles.flatten!
	$RPG_OBJECTS = nil

	validateRecreation(dataDir, dataFiles) if check
	$RPG_OBJECTS = dataFiles.map{ |df| [df, loadFile("#{dataDir}/#{df}", verbose)] }.to_h
	$CURRENT_FILE = nil
end

def saveDataFiles(dataDir)
	Dir.mkdir(dataDir) unless Dir.exist?(dataDir)
	puts "Writing patched data to: \"#{dataDir}\""
	$RPG_OBJECTS.each do |name, obj|
		save_data(obj, "#{dataDir}/#{name}#{$ENGINE_EXT}")
	end
end

def execute(func)
	return unless func
	return if $RPG_OBJECTS.empty?

	$RPG_OBJECTS.each do |name, obj|
		next if name == "MapInfos"

		if obj.class == Array
			obj.each { |o| func.call(o, name) if o }
		else
			func.call(obj, name)
		end
	end
end


#####################
#### Logging
#####################
$LOG_FILE = nil

def initLogging
	logDir = "logs"
	Dir.mkdir(logDir) unless Dir.exist?(logDir)
	$LOG_FILE = File.open("#{logDir}/#{File.basename($0, ".*")}_#{Time.now.strftime("%Y%m%d_%H%M%S")}.log", "w:UTF-8")
	$LOG_FILE.sync = true
end

# override the puts method to also log to file
module Kernel
	alias :oldputs :puts
	alias :oldprint :print
	def puts(*args)
		oldputs(*args)
		$LOG_FILE.puts *args if $LOG_FILE
	end

	def print(*args)
		oldprint(*args)
		$LOG_FILE.print *args if $LOG_FILE
	end
end


at_exit do
	$LOG_FILE.close if $LOG_FILE
	$LOG_FILE = nil
end

initLogging

APPLICATION_NAME = nil unless defined? APPLICATION_NAME

puts "#{APPLICATION_NAME} - v#{VERSION}" if APPLICATION_NAME && VERSION
# Support for the old style where I forgot that constants exist ...
puts "#{$APPLICATION_NAME} - v#{$VERSION}" if $APPLICATION_NAME && $VERSION