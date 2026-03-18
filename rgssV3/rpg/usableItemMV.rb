require_relative 'baseItemMV'

class RPG::UsableItemMV < RPG::BaseItemMV
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
		@damage = RPG::UsableItemMV::DamageMV.new(json["damage"])
		@effects = json["effects"].map { |e| RPG::UsableItemMV::EffectMV.new(e) }
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
		s << "\n" unless @effects.empty?
		return s
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
class RPG::UsableItemMV::EffectMV < RPG::UsableItem::Effect
	def initialize(json)
		super()
		@code = json["code"]
		@data_id = json["dataId"]
		@value1 = json["value1"]
		@value2 = json["value2"]
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
end

class RPG::UsableItemMV::DamageMV < RPG::UsableItem::Damage
	def initialize(json)
		super()
		@type = json["type"]
		@element_id = json["elementId"]
		@formula = json["formula"]
		@variance = json["variance"]
		@critical = json["critical"]
	end

	def elementId
		@element_id
	end
end
