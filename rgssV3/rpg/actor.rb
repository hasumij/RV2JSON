require_relative 'baseItem'

class RPG::Actor < RPG::BaseItem
	def initialize
		super
		@nickname = ''
		@class_id = 1
		@initial_level = 1
		@max_level = 99
		@character_name = ''
		@character_index = 0
		@face_name = ''
		@face_index = 0
		@equips = [0,0,0,0,0]
	end

	def initialize(json)
		super(json)
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

	def getDiff(obj)
		diffs = super
		diffs << "Nickname changed" if @nickname != obj.nickname
		diffs << "Class ID changed" if @class_id != obj.class_id
		diffs << "Initial Level changed" if @initial_level != obj.initial_level
		diffs << "Max Level changed" if @max_level != obj.max_level
		diffs << "Character Picture Name changed" if @character_name != obj.character_name
		diffs << "Character Picture Index changed" if @character_index != obj.character_index
		diffs << "Face Picture Name changed" if @face_name != obj.face_name
		diffs << "Face Picture Index changed" if @face_index != obj.face_index
		@equips.each_with_index { | eq, idx | diffs << "Equip [#{idx}] changed" if eq != obj.equips[idx] }
		return diffs
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

	def to_json(*a)
		return {
			"id" => @id,
			"characterIndex" => @character_index,
			"characterName" => @character_name,
			"classId" => @class_id,
			"equips" => @equips,
			"faceIndex" => @face_index,
			"faceName" => @face_name,
			"traits" => @features,
			"initialLevel" => @initial_level,
			"maxLevel" => @max_level,
			"name" => @name,
			"nickname" => @nickname,
			"note" => @note,
			"profile" => @description
		}.to_json(*a)
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
end
