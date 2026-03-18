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
	def initialize(json)
		super()
		@condition = RPG::EventMV::PageMV::ConditionMV.new(json["conditions"])
		@graphic = RPG::EventMV::PageMV::GraphicMV.new(json["image"])
		@move_type = json["moveType"]
		@move_speed = json["moveSpeed"]
		@move_frequency = json["moveFrequency"]
		@move_route = RPG::MoveRouteMV.new(json["moveRoute"])
		@walk_anime = json["walkAnime"]
		@step_anime = json["stepAnime"]
		@direction_fix = json["directionFix"]
		@through = json["through"]
		@priority_type = json["priorityType"]
		@trigger = json["trigger"]
		@list = json["list"].map { |e| RPG::EventCommandMV.new(e) }
	end

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
	def initialize(json)
		super()
		@tile_id = json["tileId"]
		@character_name = json["characterName"]
		@character_index = json["characterIndex"]
		@direction = json["direction"]
		@pattern = json["pattern"]
	end

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
	def initialize(json)
		super()
		@switch1_valid = json["switch1Valid"]
		@switch2_valid = json["switch2Valid"]
		@variable_valid = json["variableValid"]
		@self_switch_valid = json["selfSwitchValid"]
		@item_valid = json["itemValid"]
		@actor_valid = json["actorValid"]
		@switch1_id = json["switch1Id"]
		@switch2_id = json["switch2Id"]
		@variable_id = json["variableId"]
		@variable_value = json["variableValue"]
		@self_switch_ch = json["selfSwitchCh"]
		@item_id = json["itemId"]
		@actor_id = json["actorId"]
	end

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