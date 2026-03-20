require_relative 'baseItem'

class RPG::UsableItem < RPG::BaseItem
	def initialize
		super
		@scope = 0
		@occasion = 0
		@speed = 0
		@success_rate = 100
		@repeats = 1
		@tp_gain = 0
		@hit_type = 0
		@animation_id = 0
		@damage = RPG::UsableItem::Damage.new
		@effects = []
	end

	def initialize(json)
		super(json)
		@scope = json["scope"]
		@occasion = json["occasion"]
		@speed = json["speed"]
		@success_rate = json["successRate"]
		@repeats = json["repeats"]
		@tp_gain = json["tpGain"]
		@hit_type = json["hitType"]
		@animation_id = json["animationId"]
		@damage = RPG::UsableItem::Damage.new(json["damage"])
		@effects = json["effects"].map { |e| RPG::UsableItemMV::EffectMV.new(e) }
	end

	def updateFromJson(json)
		super(json)
		@scope = json["scope"] if json["scope"]
		@occasion = json["occasion"] if json["occasion"]
		@speed = json["speed"] if json["speed"]
		@success_rate = json["successRate"] if json["successRate"]
		@repeats = json["repeats"] if json["repeats"]
		@tp_gain = json["tpGain"] if json["tpGain"]
		@hit_type = json["hitType"] if json["hitType"]
		@animation_id = json["animationId"] if json["animationId"]
		@damage.updateFromJson(json["damage"]) if json["damage"]
		listUpdateFromJson(@effects, json["effects"])
	end

	def successRate
		@success_rate
	end

	def tpGain
		@tp_gain
	end

	def hitType
		@hit_type
	end

	def animationId
		@animation_id
	end

	def to_s
		s = super
		s << "Area of Effect: #{parseAoE(@scope)}\n"
		s << "Availabilty: #{parseAvailability(@occasion)}\n"
		s << "Speed Fix: #{@speed}\n"
		s << "Hit Rate: #{@success_rate}\n"
		s << "No. of Hits: #{@repeats}\n"
		s << "TP Gain: #{@tp_gain}\n"
		s << "Hit Type: #{parseHitType(@hit_type)}\n"
		s << "Animation: #{getAnimation(@animation_id)}\n"
		s << "Damage:\n#{@damage.to_s}"
		s << "On Use Effects:\n" unless @effects.empty?
		@effects.each { |e| s << e.to_s }
		s << "\n"
		return s
	end

	def for_opponent?
		[1, 2, 3, 4, 5, 6].include?(@scope)
	end
	def for_friend?
		[7, 8, 9, 10, 11].include?(@scope)
	end
	def for_dead_friend?
		[9, 10].include?(@scope)
	end
	def for_user?
		@scope == 11
	end
	def for_one?
		[1, 3, 7, 9, 11].include?(@scope)
	end
	def for_random?
		[3, 4, 5, 6].include?(@scope)
	end
	def number_of_targets
		for_random? ? @scope - 2 : 0
	end
	def for_all?
		[2, 8, 10].include?(@scope)
	end
	def need_selection?
		[1, 7, 9].include?(@scope)
	end
	def battle_ok?
		[0, 1].include?(@occasion)
	end
	def menu_ok?
		[0, 2].include?(@occasion)
	end
	def certain?
		@hit_type == 0
	end
	def physical?
		@hit_type == 1
	end
	def magical?
		@hit_type == 2
	end
	
	def getDiff(obj)
		diffs = super
		diffs << "Scope changed" if @scope != obj.scope
		diffs << "Occasion changed" if @occasion != obj.occasion
		diffs << "Speed changed" if @speed != obj.speed
		diffs << "Animation ID changed" if @animation_id != obj.animation_id
		diffs << "Success Rate changed" if @success_rate != obj.success_rate
		diffs << "Repeats changed" if @repeats != obj.repeats
		diffs << "TP Gain changed" if @tp_gain != obj.tp_gain
		diffs << "Hit Type changed" if @hit_type != obj.hit_type
		diffs += @damage.getDiff(obj.damage)
		@effects.each_with_index { | eff, idx | diffs += eff.getDiff(obj.effects[idx], idx) }
		return diffs
	end
	
	attr_accessor :scope
	attr_accessor :occasion
	attr_accessor :speed
	attr_accessor :animation_id
	attr_accessor :success_rate
	attr_accessor :repeats
	attr_accessor :tp_gain
	attr_accessor :hit_type
	attr_accessor :damage
	attr_accessor :effects
end

# TODO: Map out text for to_s
class RPG::UsableItem::Effect
	def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
		@code = code
		@data_id = data_id
		@value1 = value1
		@value2 = value2
	end

	def initialize(json)
		@code = json["code"]
		@data_id = json["dataId"]
		@value1 = json["value1"]
		@value2 = json["value2"]
	end

	def updateFromJson(json)
		@code = json["code"] if json["code"]
		@data_id = json["dataId"] if json["dataId"]
		@value1 = json["value1"] if json["value1"]
		@value2 = json["value2"] if json["value2"]
	end

	def dataId
		@data_id
	end

	def value1
		@value1
	end

	def value2
		@value2
	end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Effect [#{idx}]: New entry"
			return diffs
		end

		diffs << "Effect [#{idx}]: Code changed" if @code != obj.code
		diffs << "Effect [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "Effect [#{idx}]: Value 1 changed" if @value1 != obj.value1
		diffs << "Effect [#{idx}]: Value 2 changed" if @value2 != obj.value2
		return diffs
	end

	def to_s
		case @code
			when 11
				return "Recover HP: #{parseRecover(@value1, @value2)}\n"
			when 12
				return "Recover MP: #{parseRecover(@value1, @value2)}\n"
			when 13
				return "Increase TP: #{@value1.to_i}%\n"
			when 21
				return "Add State: #{getState(@data_id)} #{(@value1 * 100).to_i}%\n"
			when 22
				return "Remove State: #{getState(@data_id)} #{(@value1 * 100).to_i}%\n"
			when 31
				return "Add Ability Buff: [#{parseState(@data_id)}] #{@value1.to_i} Turn#{@value1 == 1.0 ? "" : "s"}\n"
			when 32
				return "Add Ability Debuff: [#{parseState(@data_id)}] #{@value1.to_i} Turn#{@value1 == 1.0 ? "" : "s"}\n"
			when 33
				return "Remove Ability Buff: [#{parseState(@data_id)}]\n"
			when 34
				return "Remove Ability Debuff: [#{parseState(@data_id)}]\n"
			when 41
				return "Special Effects: Escape\n"
			when 42
				return "Growth: [#{parseState(@data_id)}] + #{@value1.to_i}\n"
			when 43
				return "Acquire Skill: #{getSkill(@data_id)}\n"
			when 44
				return "Common Event: #{getComEv(@data_id)}\n"
		end
	end

	def to_json(*a)
		return {
			"code"   => @code,
			"dataId" => @data_id,
			"value1" => @value1,
			"value2" => @value2
		}.to_json(*a)
	end

	attr_accessor :code
	attr_accessor :data_id
	attr_accessor :value1
	attr_accessor :value2
end

class RPG::UsableItem::Damage
	def initialize
		@type = 0
		@element_id = 0
		@formula = '0'
		@variance = 20
		@critical = false
	end

	def initialize(json)
		@type = json["type"]
		@element_id = json["elementId"]
		@formula = json["formula"]
		@variance = json["variance"]
		@critical = json["critical"]
	end

	def updateFromJson(json)
		@type = json["type"] if json["type"]
		@element_id = json["elementId"] if json["elementId"]
		@formula = json["formula"] if json["formula"]
		@variance = json["variance"] if json["variance"]
		@critical = json["critical"] if json["critical"]
	end

	def elementId
		@element_id
	end

	def to_s
		s = ""
		s << "Type: #{parseDamageType(@type)}\n"
		s << "Attribute: #{getElement(@element_id)}\n" unless @type == 0
		s << "Formula Calculation: #{@formula}\n" unless @type == 0
		s << "Variance: #{@variance}\n" unless @type == 0
		s << "Allow Criticals: #{@critical ? "Yes" : "No"}\n" unless @type == 0
		s << "\n"
		return s
	end

	def none?
		@type == 0
	end
	def to_hp?
		[1,3,5].include?(@type)
	end
	def to_mp?
		[2,4,6].include?(@type)
	end
	def recover?
		[3,4].include?(@type)
	end
	def drain?
		[5,6].include?(@type)
	end
	def sign
		recover? ? -1 : 1
	end
	def eval(a, b, v)
		[Kernel.eval(@formula), 0].max * sign rescue 0
	end
	
	def getDiff(obj)
		diffs = []
		diffs << "Damage Type changed" if @type != obj.type
		diffs << "Damage Element ID changed" if @element_id != obj.element_id
		diffs << "Damage Formula changed" if @formula != obj.formula
		diffs << "Damage Variance changed" if @variance != obj.variance
		diffs << "Damage Critical changed" if @critical != obj.critical
		return diffs
	end

	def to_json(*a)
		return {
			"critical" => @critical,
			"elementId" => @element_id,
			"formula" => @formula,
			"type" => @type,
			"variance" => @variance
		}.to_json(*a)
	end

	attr_accessor :type
	attr_accessor :element_id
	attr_accessor :formula
	attr_accessor :variance
	attr_accessor :critical
end
