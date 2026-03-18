require_relative 'baseItemMV'

class RPG::ActorMV < RPG::BaseItemMV
	def initialize(json)
		super(json)
		@battler_name = json["battlerName"]
		@character_index = json["characterIndex"]
		@character_name = json["characterName"]
		@class_id = json["classId"]
		@equips = json["equips"]
		@face_index = json["faceIndex"]
		@face_name = json["faceName"]
		@initial_level = json["initialLevel"]
		@max_level = json["maxLevel"]
		@nickname = json["nickname"]
		@description = json["profile"]
	end

	def battlerName
		@battler_name
	end

	def characterIndex
		@character_index
	end

	def characterName
		@character_name
	end

	def classId
		@class_id
	end

	def faceIndex
		@face_index
	end

	def faceName
		@face_name
	end

	def initialLevel
		@initial_level
	end

	def maxLevel
		@max_level
	end

	def to_s
		s = "Actor: #{padVariable(@id, 3)}\n"
		s << super
		s << "Nickname: #{@nickname}\n" if @nickname && !@nickname.empty?
		s << "Class: #{getClass(@class_id, false)}\n"
		s << "Initial Level: #{@initial_level}\n"
		s << "Max Level: #{@max_level}\n"
		s << "Character Name: #{@character_name}\n"
		s << "Character Index: #{@character_index}\n"
		s << "Battler Name: #{@battler_name}\n" unless @battler_name.empty?
		s << "Face Name: #{@face_name}\n"
		s << "Face Index: #{@face_index}\n"
		s << "Initial Equipment:\n"
		s << "Weapon:    #{getWeapon(@equips[0], false)}\n"
		s << "Shield:    #{getArmor(@equips[1], false)}\n"
		s << "Head:      #{getArmor(@equips[2], false)}\n"
		s << "Body:      #{getArmor(@equips[3], false)}\n"
		s << "Accessory: #{getArmor(@equips[4], false)}\n"
		return s
	end

	attr_accessor :nickname
	attr_accessor :class_id
	attr_accessor :initial_level
	attr_accessor :max_level
	attr_accessor :character_name
	attr_accessor :character_index
	attr_accessor :face_name
	attr_accessor :face_index
	attr_accessor :equips
	attr_accessor :battler_name
end
