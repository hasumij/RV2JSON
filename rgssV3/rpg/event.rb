class RPG::Event	
	def initialize(x = 0, y = 0)
		@id = 0
		@name = ""
		@x = x
		@y = y
		@pages = [RPG::Event::Page.new]
	end

	def updateFromJson(json)
		updateItemFromJson(@id, json["id"])
		updateItemFromJson(@name, json["name"])
		updateItemFromJson(@x, json["x"])
		updateItemFromJson(@y, json["y"])
		listUpdateFromJson(@pages, json["pages"])
	end

	def ==(obj)
		return false unless obj
		return false unless @id == obj.id
		return false unless @name == obj.name
		return false unless @x == obj.x
		return false unless @y == obj.y
		return false unless @pages == obj.pages
		return true
	end

	def to_s
		s = ""
		s << "ID: #{@id}\n"
		s << "Name: #{@name}\n"
		s << "X: #{@x}\n"
		s << "Y: #{@y}\n"
		@pages.each { |p| s << p.to_s }
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"name" => @name,
			"note" => @note,
			"pages" => @pages,
			"x" => @x,
			"y" => @y
		}.to_json(*a)
	end

	attr_accessor :id
	attr_accessor :name
	attr_accessor :x
	attr_accessor :y
	attr_accessor :pages
end

class RPG::Event::Page
	def initialize
		@condition = RPG::Event::Page::Condition.new
		@graphic = RPG::Event::Page::Graphic.new
		@move_type = 0
		@move_speed = 3
		@move_frequency = 3
		@move_route = RPG::MoveRoute.new
		@walk_anime = true
		@step_anime = false
		@direction_fix = false
		@through = false
		@priority_type = 0
		@trigger = 0
		@list = [RPG::EventCommand.new]
	end

	def initialize(json)
		@condition = RPG::EventMV::Page::Condition.new(json["conditions"])
		@graphic = RPG::EventMV::Page::Graphic.new(json["image"])
		@move_type = json["moveType"]
		@move_speed = json["moveSpeed"]
		@move_frequency = json["moveFrequency"]
		@move_route = RPG::MoveRoute.new(json["moveRoute"])
		@walk_anime = json["walkAnime"]
		@step_anime = json["stepAnime"]
		@direction_fix = json["directionFix"]
		@through = json["through"]
		@priority_type = json["priorityType"]
		@trigger = json["trigger"]
		@list = json["list"].map { |e| RPG::EventCommand.new(e) }
	end

	def updateFromJson(json)
		updateItemFromJson(@condition, json["conditions"])
		updateItemFromJson(@graphic, json["image"])
		updateItemFromJson(@move_type, json["moveType"])
		updateItemFromJson(@move_speed, json["moveSpeed"])
		updateItemFromJson(@move_frequency, json["moveFrequency"])
		updateItemFromJson(@move_route, json["moveRoute"])
		updateItemFromJson(@walk_anime, json["walkAnime"])
		updateItemFromJson(@step_anime, json["stepAnime"])
		updateItemFromJson(@direction_fix, json["directionFix"])
		updateItemFromJson(@through, json["through"])
		updateItemFromJson(@priority_type, json["priorityType"])
		updateItemFromJson(@trigger, json["trigger"])
		listUpdateFromJson(@list, json["list"])
	end

	def ==(obj)
		return false unless obj
		return false unless @condition == obj.condition
		return false unless @graphic == obj.graphic
		return false unless @move_type == obj.move_type
		return false unless @move_speed == obj.move_speed
		return false unless @move_frequency == obj.move_frequency
		return false unless @move_route == obj.move_route
		return false unless @walk_anime == obj.walk_anime
		return false unless @step_anime == obj.step_anime
		return false unless @direction_fix == obj.direction_fix
		return false unless @through == obj.through
		return false unless @priority_type == obj.priority_type
		return false unless @trigger == obj.trigger
		return false unless @list == obj.list
		return true
	end

	
	def to_s
		s = ""
		s << "Condition: #{@condition.to_s}\n"
		s << "Graphic: #{@graphic.to_s}\n"
		s << "Move Type: #{@move_type}\n"
		s << "Move Speed: #{@move_speed}\n"
		s << "Move Frequency: #{@move_frequency}\n"
		s << "Move Route:#{@move_route.to_s}\n" if @move_type == 3 && @move_route
		s << "Walk Animation: #{@walk_anime}\n"
		s << "Step Animation: #{@step_anime}\n"
		s << "Direction Fix: #{@direction_fix}\n"
		s << "Through: #{@through}\n"
		s << "Priority Type: #{@priority_type}\n"
		s << "Trigger: #{@trigger}\n"
		s << dumpEventArray(@list)
		return s
	end

	def to_json(*a)
		return {
			"conditions" => @condition,
			"directionFix" => @direction_fix,
			"image" => @graphic,
			"list" => @list,
			"moveFrequency" => @move_frequency,
			"moveRoute" => @move_route,
			"moveSpeed" => @move_speed,
			"moveType" => @move_type,
			"priorityType" => @priority_type,
			"stepAnime" => @step_anime,
			"through" => @through,
			"trigger" => @trigger,
			"walkAnime" => @walk_anime
		}.to_json(*a)
	end

	attr_accessor :condition
	attr_accessor :graphic
	attr_accessor :move_type
	attr_accessor :move_speed
	attr_accessor :move_frequency
	attr_accessor :move_route
	attr_accessor :walk_anime
	attr_accessor :step_anime
	attr_accessor :direction_fix
	attr_accessor :through
	attr_accessor :priority_type
	attr_accessor :trigger
	attr_accessor :list
end

class RPG::Event::Page::Graphic
	def initialize
		@tile_id = 0
		@character_name = ""
		@character_index = 0
		@direction = 2
		@pattern = 0
	end

	def initialize(json)
		@tile_id = json["tileId"]
		@character_name = json["characterName"]
		@character_index = json["characterIndex"]
		@direction = json["direction"]
		@pattern = json["pattern"]
	end

	def updateFromJson(json)
		updateItemFromJson(@tile_id, json["tileId"])
		updateItemFromJson(@character_name, json["characterName"])
		updateItemFromJson(@character_index, json["characterIndex"])
		updateItemFromJson(@direction, json["direction"])
		updateItemFromJson(@pattern, json["pattern"])
	end

	def ==(obj)
		return false unless obj
		return false unless @tile_id == obj.tile_id
		return false unless @character_name == obj.character_name
		return false unless @character_index == obj.character_index
		return false unless @direction == obj.direction
		return false unless @pattern == obj.pattern
		return true
	end

	def to_s
		s = ""
		s << "Tile ID: #{@tile_id}\n"
		s << "Character Name: #{@character_name}\n"
		s << "Character Index: #{@character_index}\n"
		s << "Direction: #{@direction}\n"
		s << "Pattern: #{@pattern}\n"
		return s
	end

	def to_json(*a)
		return {
			"tileId" => @tile_id,
			"characterName" => @character_name,
			"direction" => @direction,
			"pattern" => @pattern,
			"characterIndex" => @character_index
		}.to_json(*a)
	end

	attr_accessor :tile_id
	attr_accessor :character_name
	attr_accessor :character_index
	attr_accessor :direction
	attr_accessor :pattern
end

class RPG::Event::Page::Condition
	def initialize
		@switch1_valid = false
		@switch2_valid = false
		@variable_valid = false
		@self_switch_valid = false
		@item_valid = false
		@actor_valid = false
		@switch1_id = 1
		@switch2_id = 1
		@variable_id = 1
		@variable_value = 0
		@self_switch_ch = "A"
		@item_id = 1
		@actor_id = 1
	end

	def initialize(json)
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

	def updateFromJson(json)
		updateItemFromJson(@switch1_valid, json["switch1Valid"])
		updateItemFromJson(@switch2_valid, json["switch2Valid"])
		updateItemFromJson(@variable_valid, json["variableValid"])
		updateItemFromJson(@self_switch_valid, json["selfSwitchValid"])
		updateItemFromJson(@item_valid, json["itemValid"])
		updateItemFromJson(@actor_valid, json["actorValid"])
		updateItemFromJson(@switch1_id, json["switch1Id"])
		updateItemFromJson(@switch2_id, json["switch2Id"])
		updateItemFromJson(@variable_id, json["variableId"])
		updateItemFromJson(@variable_value, json["variableValue"])
		updateItemFromJson(@self_switch_ch, json["selfSwitchCh"])
		updateItemFromJson(@item_id, json["itemId"])
		updateItemFromJson(@actor_id, json["actorId"])
	end


	def ==(obj)
		return false unless obj
		return false unless @switch1_valid == obj.switch1_valid
		return false unless @switch2_valid == obj.switch2_valid
		return false unless @variable_valid == obj.variable_valid
		return false unless @self_switch_valid == obj.self_switch_valid
		return false unless @item_valid == obj.item_valid
		return false unless @actor_valid == obj.actor_valid
		return false unless @switch1_id == obj.switch1_id
		return false unless @switch2_id == obj.switch2_id
		return false unless @variable_id == obj.variable_id
		return false unless @variable_value == obj.variable_value
		return false unless @self_switch_ch == obj.self_switch_ch
		return false unless @item_id == obj.item_id
		return false unless @actor_id == obj.actor_id
		return true
	end

	def to_s
		s = ""
		s << "Switch 1 ID: #{@switch1_id}\n" if @switch1_valid
		s << "Switch 2 ID: #{@switch2_id}\n" if @switch2_valid
		s << "Variable ID: #{@variable_id}\n" if @variable_valid
		s << "Variable Value: #{@variable_value}\n" if @variable_valid
		s << "Self Switch: #{@self_switch_ch}\n" if @self_switch_valid
		s << "Item ID: #{@item_id}\n" if @item_valid
		s << "Actor ID: #{@actor_id}\n" if @actor_valid
		return s
	end

	def to_json(*a)
		return {
			"actorId" => @actor_id,
			"actorValid" => @actor_valid,
			"itemId" => @item_id,
			"itemValid" => @item_valid,
			"selfSwitchCh" => @self_switch_ch,
			"selfSwitchValid" => @self_switch_valid,
			"switch1Id" => @switch1_id,
			"switch1Valid" => @switch1_valid,
			"switch2Id" => @switch2_id,
			"switch2Valid" => @switch2_valid,
			"variableId" => @variable_id,
			"variableValid" => @variable_valid,
			"variableValue" => @variable_value
		}.to_json(*a)
	end

	attr_accessor :switch1_valid
	attr_accessor :switch2_valid
	attr_accessor :variable_valid
	attr_accessor :self_switch_valid
	attr_accessor :item_valid
	attr_accessor :actor_valid
	attr_accessor :switch1_id
	attr_accessor :switch2_id
	attr_accessor :variable_id
	attr_accessor :variable_value
	attr_accessor :self_switch_ch
	attr_accessor :item_id
	attr_accessor :actor_id
end