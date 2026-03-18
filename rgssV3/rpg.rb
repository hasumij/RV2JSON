require_relative 'table'
require_relative 'color'
require_relative 'tone'

require 'json'

class RPG
end

require_relative 'rpg/actor'
require_relative 'rpg/animation'
require_relative 'rpg/armor'
require_relative 'rpg/audioFile'
require_relative 'rpg/baseItem'
require_relative 'rpg/class'
require_relative 'rpg/commonEvent'
require_relative 'rpg/enemy'
require_relative 'rpg/equipItem'
require_relative 'rpg/event'
require_relative 'rpg/eventCommand'
require_relative 'rpg/item'
require_relative 'rpg/map'
require_relative 'rpg/mapInfo'
require_relative 'rpg/moveCommand'
require_relative 'rpg/moveRoute'
require_relative 'rpg/skill'
require_relative 'rpg/state'
require_relative 'rpg/system'
require_relative 'rpg/tileset'
require_relative 'rpg/troop'
require_relative 'rpg/usableItem'
require_relative 'rpg/weapon'

require_relative 'rpg/actorMV'
require_relative 'rpg/systemMV'
require_relative 'rpg/itemMV'
require_relative 'rpg/classMV'
require_relative 'rpg/skillMV'
require_relative 'rpg/weaponMV'
require_relative 'rpg/armorMV'
require_relative 'rpg/stateMV'
require_relative 'rpg/mapinfoMV'
require_relative 'rpg/animationMV'
require_relative 'rpg/troopMV'
require_relative 'rpg/tilesetMV'
require_relative 'rpg/enemyMV'
require_relative 'rpg/commonEventMV'
require_relative 'rpg/mapMV'

module FinalClass
end

class Scene_File
end

class Scene_MenuBase
end

class Window_Selectable
end

ENGINES = {
:vxace => ".rvdata2",
:vx    => ".rvdata",
:mv    => ".json"
}

# TODO: This expects for miscV3 to be loaded ...
#       while it does check if the var is set, this is not good style
def rpgvxace?
	return $ENGINE == :vxace if $ENGINE
	return true
end

def json2Obj(fN, json)
	return RPG::SystemMV.new(json) if fN == "System"
	return RPG::MapMV.new(json) if /Map\d\d\d/.match(fN)

	if fN == "MapInfos"
		obj = Hash.new
		json.each_with_index do |j, i|
			if j
				o = RPG::MapInfoMV.new(j)
				obj[o.id] = o
			else
				obj[i] = nil
			end
		end
		return obj
	end

	obj = []

	json.each do |j|
		if j
			obj << case fN
				when "Actors"; RPG::ActorMV.new(j)
				when "Items"; RPG::ItemMV.new(j)
				when "Classes"; RPG::ClassMV.new(j)
				when "Skills"; RPG::SkillMV.new(j)
				when "Weapons"; RPG::WeaponMV.new(j)
				when "Armors"; RPG::ArmorMV.new(j)
				when "States"; RPG::StateMV.new(j)
				when "Animations"; RPG::AnimationMV.new(j)
				when "Troops"; RPG::TroopMV.new(j)
				when "Tilesets"; RPG::TilesetMV.new(j)
				when "Enemies"; RPG::EnemyMV.new(j)
				when "CommonEvents"; RPG::CommonEventMV.new(j)
				else puts "Unknown Object Type: #{fN}"
			end
		else
			obj << nil
		end
	end

	return obj
end

### From the RPG Maker documentation
def load_data(filename)
	unless File.exist?(filename)
		puts "Error: File: #{filename} does not exist."
		return nil
	end

	if File.zero?(filename)
		puts "Warning: File: #{filename} is empty, skipping."
		return nil
	end

	ext = File.extname(filename)

	if ext == ENGINES[:vx] || ext == ENGINES[:vxace]
		File.open(filename, "rb") { |f| return Marshal.load(f) }
	elsif ext == ".json"
		File.open(filename, "r:BOM|UTF-8") { |f| return json2Obj(File.basename(filename, ".*"), JSON.parse(f.read)) }
	else
		puts "ERROR: Unknown file type: #{filename} skipping ..."
		return nil
	end
end

### From the RPG Maker documentation
def save_data(obj, filename, force_json = false)
	if $ENGINE == :vxace || $ENGINE == :vx
		if force_json
			File.open("#{filename}.json", "w:UTF-8") { |f| f.write(JSON.pretty_generate obj) }
		else
			File.open("#{filename}", "wb") { |f| Marshal.dump(obj, f) }
		end
	elsif $ENGINE == :mv
		# MapInfos is stored as an array in the json file
		# but loaded as a hash for convenience, therefore,
		# it needs to be converted back into an array before
		# storing it to the output file
		if filename.include?"/MapInfos"
			d = []
			obj.each { |k, v| d << v }
			obj = d
		end

		File.open("#{filename}", "w:UTF-8") { |f| f.write(JSON.pretty_generate obj) }
	else
		puts "ERROR: Unknown Engine: #{$ENGINE} skipping ..."
	end
end
