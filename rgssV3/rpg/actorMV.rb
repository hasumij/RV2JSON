require_relative 'actor'

class RPG::ActorMV < RPG::Actor
	def initialize(json)
		super(json)
		@battler_name = json["battlerName"]
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
		s << super
		s << "Battler Name: #{@battler_name}\n" unless @battler_name.empty?
		return s
	end

	def to_json(*a)
		return super.merge({
			"battlerName" => @battler_name,
		})
	end

	attr_accessor :battler_name
end
