require_relative 'event'
require_relative 'eventCommandMV'
require_relative 'moveRouteMV'

class RPG::EventMV < RPG::Event
	def initialize(json)
		super()
		@id = json["id"]
		@name = json["name"]
		@x = json["x"]
		@y = json["y"]
		@note = json["note"]
		@pages = json["pages"].map { |p| RPG::EventMV::PageMV.new(p) }
	end

	attr_accessor :note
end

class RPG::EventMV::PageMV < RPG::Event::Page
	def image
		@graphic
	end

	def moveType
		@move_type
	end

	def moveSpeed
		@move_speed
	end

	def moveFrequency
		@move_frequency
	end

	def moveRoute
		@move_route
	end

	def walkAnime
		@walk_anime
	end

	def stepAnime
		@step_anime
	end

	def directionFix
		@direction_fix
	end

	def priorityType
		@priority_type
	end

	def image
		@graphic
	end

end

class RPG::EventMV::PageMV::GraphicMV < RPG::Event::Page::Graphic
	def tileId
		@tile_id
	end

	def characterName
		@character_name
	end

	def characterIndex
		@character_index
	end
end

class RPG::EventMV::PageMV::ConditionMV < RPG::Event::Page::Condition
	def switch1Valid
		@switch1_valid
	end

	def switch2Valid
		@switch2_valid
	end

	def variableValid
		@variable_valid
	end

	def selfSwitchValid
		@self_switch_valid
	end

	def itemValid
		@item_valid
	end

	def actorValid
		@actor_valid
	end

	def switch1Id
		@switch1_id
	end

	def switch2Id
		@switch2_id
	end

	def variableId
		@variable_id
	end

	def variableValue
		@variable_value
	end

	def selfSwitchCh
		@self_switch_ch
	end

	def itemId
		@item_id
	end

	def actorId
		@actor_id
	end
end