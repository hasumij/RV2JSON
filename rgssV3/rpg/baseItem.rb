require_relative 'utils'

class RPG::BaseItem
	def initialize
		@id = 0
		@name = ''
		@icon_index = 0
		@description = ''
		@features = []
		@note = ''
	end

	def initialize(json)
		@id = json["id"]
		@name = json["name"]
		@icon_index = json["iconIndex"]
		@description = json["description"]
		@features = json["traits"].map { |t| RPG::BaseItemMV::FeatureMV.new(t) } if json["traits"]
		@note = json["note"]
	end

	def iconIndex
		@icon_index
	end

	def traits
		@features
	end

	def getDiff(obj)
		diffs = []
		diffs << "ID changed" if @id != obj.id
		diffs << "Name changed" if @name != obj.name
		diffs << "Icon Index changed" if @icon_index != obj.icon_index
		diffs << "Description changed" if @description != obj.description
		@features.each_with_index { | f, idx | diffs += f.getDiff(obj.features[idx], idx) }
		diffs << "Note changed" if @note != obj.note
		return diffs
	end
	
	def to_s
		s = ""
		s << "Name: #{@name}\n"
		s << "Icon Index: #{@icon_index}\n" if @icon_index
		s << "Description:\n#{@description.gsub(//, "")}\n" if @description && !@description.empty?
		s << "Features:\n" unless @features.empty?
		@features.each {|f| s << f.to_s}
		s << "Note:\n#{@note}\n" if @note && !@note.empty?
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"name" => @name,
			"iconIndex" => @icon_index,
			"description" => @description,
			"traits" => @features,
			"note" => @note,
		}
	end

  attr_accessor :id
  attr_accessor :name
  attr_accessor :icon_index
  attr_accessor :description
  attr_accessor :features
  attr_accessor :note
end

# TODO: Map out text for to_s
class RPG::BaseItem::Feature
	def initialize(code = 0, data_id = 0, value = 0)
		@code = code
		@data_id = data_id
		@value = value
	end

	def initialize(json)
		super()
		@code = json["code"]
		@data_id = json["dataId"]
		@value = json["value"]
	end

	def dataId
		@data_id
	end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Feature [#{idx}]: New entry"
			return diffs
		end

		diffs << "Feature [#{idx}]: Code changed" if @code != obj.code
		diffs << "Feature [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "Feature [#{idx}]: Value changed" if @value != obj.value
		return diffs
	end

	def to_s
		case @code
			when 11
				return "Attribute Efficiency: #{getElement(@data_id)} * #{(@value * 100).to_i}%\n"
			when 12
				return "Weak Effectivness: [#{parseState(@data_id)}] * #{(@value * 100).to_i}%\n"
			when 13
				return "State Efficiency: #{getState(@data_id)} * #{(@value * 100).to_i}%\n"
			when 14
				return "State Nullification: #{getState(@data_id)}\n"
			when 21
				return "Normal Ability Value: [#{parseState(@data_id)}] * #{(@value * 100).to_i}%\n"
			when 22
				return "Additional Ability Value: [#{parseAddState(@data_id)}] * #{(@value * 100).to_i}%\n"
			when 23
				return "Special Ability Value: [#{parseSpecialState(@data_id)}] * #{(@value * 100).to_i}%\n"
			when 31
				return "Attribute on Attack: [#{getElement(@data_id)}]\n"
			when 32
				return "State on Attack: #{getState(@data_id)} + #{(@value * 100).to_i}%\n"
			when 33
				return "Attack Speed Correction: #{@value.to_i}\n"
			when 34
				return "Additional Attacks: #{@value.to_i}\n"
			when 41
				return "Additional Skill Type: [#{getSkillType(@data_id)}]\n"
			when 42
				return "Sealed Skill Type: [#{getSkillType(@data_id)}]\n"
			when 43
				return "Additional Skill: #{getSkill(@data_id)}\n"
			when 44
				return "Sealed Skill: #{getSkill(@data_id)}\n"
			when 51
				return "Weapon Equipment Type: #{getWeaponType(@data_id)}\n"
			when 52
				return "Armor Equipment Type: #{getArmorType(@data_id)}\n"
			when 53
				return "Fixed Equipment: #{parseEquipment(@data_id)}\n"
			when 54
				return "Sealed Equipment: #{parseEquipment(@data_id)}\n"
			when 55
				return "Slot Type: Dual Wield\n"
			when 61
				return "Number of Additional Actions: #{(@value * 100).to_i}%\n"
			when 62
				return "Special Flag: #{parseSpecialFlag(@data_id)}\n"
			when 63
				return "Extinguishment Effect: #{parseExtEffect(@data_id)}\n"
			when 64
				return "Party Ability: #{parsePartyAbility(@data_id)}\n"
		end
	end

	def to_json(*a)
		return {
			"code" => @code,
			"dataId" => @data_id,
			"value" => @value
		}.to_json(*a)
	end

	attr_accessor :code
	attr_accessor :data_id
	attr_accessor :value
end
