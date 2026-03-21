require_relative 'utils'

# Static variable for the current set of MoveCommands -- I suck at ruby and while ugly, this works ...
$moveCommands = nil
$currentMCIndex = nil

class RPG::EventCommand
	def initialize(code = 0, indent = 0, parameters = [])
		@code = code
		@indent = indent
		@parameters = parameters
	end

	def updateFromJson(json)
		@code = json["code"] if json["code"]
		@indent = json["indent"] if json["indent"]
		# updateParametersFromJson(@parameters, json["parameters"])
		if json["parameters"]
			@parameters.clear
			json["parameters"].each_with_index do |p, idx|
				case @code
				when 132 # Change Battle BGM
					if p.is_a?(Hash)
						@parameters.push(RPG::BGM.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 133 # Change Battle End ME
					if p.is_a?(Hash)
						@parameters.push(RPG::ME.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 138 # Change Window Color
					if p.is_a?(Hash)
						@parameters.push(Tone.new(p["red"], p["green"], p["blue"], p["gray"]))
					else
						@parameters.push(p)
					end
				when 205 # Set Move Route
					if p.is_a?(Hash) && p["list"]
						$moveCommands = RPG::MoveRoute.new
						$currentMCIndex = 0
						$moveCommands.initFromJson(p)
						@parameters.push($moveCommands)
					else
						@parameters.push(p)
					end
				when 223 # Tint Screen
					if p.is_a?(Hash)
						@parameters.push(Tone.new(p["red"], p["green"], p["blue"], p["gray"]))
					else
						@parameters.push(p)
					end
				when 224 # Screen Flash
					if p.is_a?(Hash)
						@parameters.push(Color.new(p["red"], p["green"], p["blue"], p["alpha"]))
					else
						@parameters.push(p)
					end
				when 234 # Tint Picture
					if p.is_a?(Hash)
						@parameters.push(Tone.new(p["red"], p["green"], p["blue"], p["gray"]))
					else
						@parameters.push(p)
					end
				when 241 # Play BGM
					if p.is_a?(Hash)
						@parameters.push(RPG::BGM.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 245 # Play BGS
					if p.is_a?(Hash)
						@parameters.push(RPG::BGS.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 249 # Play ME
					if p.is_a?(Hash)
						@parameters.push(RPG::ME.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 250 # Play SE
					if p.is_a?(Hash)
						@parameters.push(RPG::SE.new(p["name"], p["pitch"], p["volume"]))
					else
						@parameters.push(p)
					end
				when 505 # Move Route - Move Command
					if p.is_a?(Hash) && p["code"]
						@parameters.push($moveCommands.list[$currentMCIndex])
						$currentMCIndex += 1
					else
						@parameters.push(p)
					end
				else
					@parameters.push(p)
				end
			end
		end
	end

	def ==(obj)
		return false unless obj
		return false unless @code == obj.code
		return false unless @indent == obj.indent
		return false unless @parameters == obj.parameters
		return true
	end



	def to_s
		case @code
			when 101 #"Show Text",
				s = "Display Text:"
				unless @parameters[0].empty?
					s << " '#{@parameters[0]}', #{@parameters[1]}, "
					s << case @parameters[2]
						when 0; "Window"
						when 1; "Dim"
						when 2; "Transparent"
					end
					s << ", "
					s << case @parameters[3]
						when 0; "Top"
						when 1; "Middle"
						when 2; "Bottom"
					end
				end
				return s
			when 102 #"Show Choices",
				s = ""
				@parameters.each_with_index { |p, i| s << " #{p}," unless i+1 == @parameters.length }
				s.chop!
				return "Display Choices:#{s}"
			when 103 #"Input Number",
				return "Numeric Input Processing: #{getVariable(@parameters[0])}, #{@parameters[1]} Digit(s)"
			when 104 #"Select Item",
				return "Item Selection Processing: #{getVariable(@parameters[0])}"
			when 105 #"Show Scrolling Text",
				return "Display Scrolling Text: Speed #{@parameters[0]}"
			when 108 #"Comment",
				return "Comment: #{@parameters[0]}"
			when 111 #"Conditional Branch",
				text = ""
				case @parameters[0]
					when 0 # Switch
						text = "Switch #{getSwitch(@parameters[1])} == #{parseSwitch(@parameters[2])}"
					when 1 # Variable
						text = "Variable #{getVariable(@parameters[1])} #{parseCompare(@parameters[4])} #{parseValue(@parameters[2], @parameters[3])}"
					when 2 # Self-Switch
						text = "Self-Switch #{@parameters[1]} = #{parseSwitch(@parameters[2])}"
					when 3 # Timer
						min, sec = parseTime(@parameters[1])
						text = "Timer #{min} Minutes #{sec} Seconds or #{parseGL(@parameters[2])}"
					when 4 # Actor has X
						s = case @parameters[2]
							when 0; "Position in the Party"
							when 1; "Name '#{@parameters[3]}' Applied"
							when 2; "#{getClass(@parameters[3])} Applied"
							when 3; "#{getSkill(@parameters[3])} Acquired"
							when 4; "#{getWeapon(@parameters[3])} Equipped"
							when 5; "#{getArmor(@parameters[3])} Equipped"
							when 6; "#{getState(@parameters[3])} Applied"
						end
						text = "#{getActor(@parameters[1])} has #{s}"
					when 5 # Enempy
						text = "[#{@parameters[1]+1}. ] has #{@parameters[2] == 0 ? "Appeared" : "#{getState(@parameters[3])} Inflicted"}"
					when 6 # Character
						text = "#{parseEvent(@parameters[1])} has #{parseButton(@parameters[2])}"
					when 7 # Currency
						text = "Currenty is #{@parameters[1]} or #{parseGL(@parameters[2])}"
					when 8 # Item
						text = "Item #{getItem(@parameters[1])} is Present"
					when 9 # Weapon
						text = "Weapon #{getWeapon(@parameters[1])} is Present#{parseIncEquip(@parameters[2])}"
					when 10 # Armor
						text = "Armor #{getArmor(@parameters[1])} is Present#{parseIncEquip(@parameters[2])}"
					when 11 # Button
						text = "Button #{parseButton(@parameters[1])} is Being Pressed"
					when 12 # Script
						text = "Script: #{@parameters[1]}"
					when 13 # Vehicle
						text = "#{parseVehicle(@parameters[1])} is Being Ridden"
				end
				return "Conditional Branch: #{text}"
			when 112 #"Loop",
				return "Loop"
			when 113 #"Break Loop",
				return "Break Loop"
			when 115 #"Exit Event Processing",
				return "End Event Processing"
			when 117 #"Common Event",
				return "Common Event: #{getComEv(@parameters[0])}"
			when 118 #"Label",
				return "Label: #{@parameters[0]}"
			when 119 #"Jump to Label",
			return "Jump to Label: #{@parameters[0]}"
			when 121 #"Control Switches",
				return "Switch Operation: #{getSwitch(@parameters[0])} = #{parseSwitch(@parameters[2])}" if @parameters[0] == @parameters[1]
				return "Switch Operation: [#{padVariable(@parameters[0])}..#{padVariable(@parameters[1])}}] = #{parseSwitch(@parameters[2])}"
			when 122 #"Control Variables",
				if @parameters[0] == @parameters[1]
					range = getVariable(@parameters[0])
				else
					range = "[#{padVariable(@parameters[0])}..#{padVariable(@parameters[1])}]"
				end
				operand = case @parameters[3]
					when 0; "#{@parameters[4]}"
					when 1; "Variable #{getVariable(@parameters[4])}"
					when 2; "Random ( #{@parameters[4]}..#{@parameters[5]} )"
					when 3 # Game Data
						case @parameters[4]
							when 0, 1, 2; "#{parseShopItem(@parameters[4], @parameters[5])} is Present"
							when 3; "#{getActor(@parameters[5])}'s #{parseActorState(@parameters[6])}"
							when 4; "#{parseActor(0, @parameters[5])}'s #{parseEnemyState(@parameters[6])}"
							when 5; "#{parseEvent(@parameters[5])}'s #{parsePosStr(@parameters[6])}"
							when 6; "#{parsePartySlot(@parameters[5])}'s Actor ID"
							when 7; parseVarOptOther(@parameters[5])
						end
					when 4; operand = "#{@parameters[4]}"
				end
				
				return "Variable Operation: #{range} #{parseOperator(@parameters[2])}= #{operand}"
			when 123 #"Control Self Switch",
				return "Self-Switch Operation: #{@parameters[0]} = #{parseSwitch(@parameters[1])}"
			when 124 #"Control Timer",
				if @parameters[0] == 0
					min, sec = parseTime(@parameters[1])
					return "Timer Operation: Start (#{min} Minutes #{sec} Seconds)"
				else
					return "Timer Operation: Stop"
				end
			when 125 #"Change Gold",
				return "Change Currency: #{parseOperation(@parameters[0])} #{parseValue(@parameters[1], @parameters[2])}"
			when 126 #"Change Items",
				return "Change Item: #{getItem(@parameters[0])} #{parseOperation(@parameters[1])} #{parseValue(@parameters[2], @parameters[3])}"
			when 127 #"Change Weapons",
				return "Change Weapon: #{getWeapon(@parameters[0])} #{parseOperation(@parameters[1])} #{parseValue(@parameters[2], @parameters[3])}#{parseIncEquip(@parameters[4])}"
			when 128 #"Change Armor",
				return "Change Armor: #{getArmor(@parameters[0])} #{parseOperation(@parameters[1])} #{parseValue(@parameters[2], @parameters[3])}#{parseIncEquip(@parameters[4])}"
			when 129 #"Change Party Member",
				return "Change Party Member: #{@parameters[1] == 0 ? "Add" : "Remove"} #{getActor(@parameters[0])}#{@parameters[2] == 1 ? ", Initialize" : "" }"
			when 132 #"Change Battle BGM",
				return "Change Battle BGM: #{parseAudio(@parameters[0])}"
			when 133 #"Change Battle End ME",
				return "Change Battle End ME: #{parseAudio(@parameters[0])}"
			when 134 #"Change Save Access",
				return "Change Save Access: #{parseAccess(@parameters[0])}"
			when 135 #"Change Menu Access",
				return "Change Menu Access: #{parseAccess(@parameters[0])}"
			when 136 #"Change Encounter Disable",
				return "Change Encounter Access: #{parseAccess(@parameters[0])}"
			when 137 #"Change Formation Access",
				return "Change Formation Access: #{parseAccess(@parameters[0])}"
			when 138 #"Change Window Color",
				return "Change Window Color: #{@parameters[0]}"
			when 201 #"Transfer Player",
				param = @parameters[0] == 0 ? parseMapPosition(@parameters[1], @parameters[2], @parameters[3]) : parseVariable3(@parameters[1], @parameters[2], @parameters[3])
				dir  = ", #{parseButton(@parameters[4])}" unless @parameters[4] == 0
				fade = ", #{parseFade(@parameters[5])}" unless @parameters[5] == 0
				return "Teleport: #{param}#{dir}#{fade}"
			when 202 #"Set Vehicle Location",
				return "Change Vehicle Position: #{parseVehicle(@parameters[0])}, #{@parameters[1] == 0 ? parseMapPosition(@parameters[2], @parameters[3], @parameters[4]) : parseVariable3(@parameters[2], @parameters[3], @parameters[4])}"
			when 203 #"Set Event Location",
				s = case @parameters[1]
					when 0; parsePosition(@parameters[2], @parameters[3])
					when 1; parseVariable2(@parameters[2], @parameters[3])
					when 2; "Exchange Position With Event #{parseEvent(@parameters[2])}"
				end
				return "Change Event Position: #{parseEvent(@parameters[0])}, #{s}#{@parameters[4] != 0 ? ", #{parseButton(@parameters[4])}" : ""}"
			when 204 #"Scroll Map",
				return "Scroll Map: #{parseButton(@parameters[0])}, #{@parameters[1]}, #{@parameters[2]}"
			when 205 #"Set Move Route",
				raise "Given event is not a MoveRoute, its class is: #{@parameters[1].class}" unless @parameters[1].class == RPG::MoveRoute || @parameters[1].class.superclass == RPG::MoveRoute
				return "Define Movement Route: #{parseEvent(@parameters[0])}#{parseMoveRouteOptions(@parameters[1])}"
			when 206 #"Getting On and Off Vehicles",
				return "Board or Exit Vehicle"
			when 211 #"Change Transparency",
				return "Change Transparency State: #{parseSwitch(@parameters[0])}"
			when 212 #"Show Animation",
				return "Display Animation: #{parseEvent(@parameters[0])}, #{getAnimation(@parameters[1])}#{parseWait(@parameters[2])}"
			when 213 #"Show Balloon Icon",
				return "Display Speech Balloon: #{parseEvent(@parameters[0])} #{parseBalloon(@parameters[1])}#{parseWait(@parameters[2])}"
			when 214 #"Temporarily Erase Event",
				return "Temporary Event Removal"
			when 216 #"Change Player Followers",
				return "Change Single File Walking: #{parseSwitch(@parameters[0])}"
			when 217 #"Gather Followers",
				return "Set Single File Members"
			when 221 #"Fadeout Screen",
				return "Fade-Out Screen"
			when 222 #"Fadein Screen",
				return "Fade-In Screen"
			when 223 #"Tint Screen",
				return "Change Screen Color Tone: #{@parameters[0]}, @#{@parameters[1]}#{parseWait(@parameters[2])}"
			when 224 #"Screen Flash",
				return "Flash Screen: #{@parameters[0]}, @#{@parameters[1]}#{parseWait(@parameters[2])}"
			when 225 #"Screen Shake",
				return "Shake Screen: #{@parameters[0]}, #{@parameters[1]}, @#{@parameters[2]}#{parseWait(@parameters[3])}"
			when 230 #"Wait",
				return "Wait: #{@parameters[0]} Frames"
			when 231 #"Show Picture",
				return "Display Picture: #{@parameters[0]}, #{parseImage(@parameters[1])}, #{parseImgPos(@parameters[2], @parameters[3], @parameters[4], @parameters[5])}, (#{@parameters[6]}%,#{@parameters[7]}%), #{@parameters[8]}, #{parseBlendType(@parameters[9])}"
			when 232 #"Move Picture",
				return "Move Picture: #{@parameters[0]}, #{parseImgPos(@parameters[2], @parameters[3], @parameters[4], @parameters[5])}, (#{@parameters[6]}%,#{@parameters[7]}%), #{@parameters[8]}, #{parseBlendType(@parameters[9])}, @#{@parameters[10]}#{parseWait(@parameters[11])}"
			when 233 #"Rotate Picture",
				return "Rotate Picture: #{@parameters[0]}, +#{@parameters[1]}"
			when 234 #"Tint Picture",
				return "Change Picture Color Tone: #{@parameters[0]}, #{@parameters[1]}, @#{@parameters[2]}#{parseWait(@parameters[3])}"
			when 235 #"Erase Picture",
				return "Clear Picture: #{@parameters[0]}"
			when 236 #"Set Weather",
				return "Set Weather Effects: #{@parameters[0].capitalize}, @#{@parameters[2]}#{parseWait(@parameters[3])}"
			when 241 #"Play BGM",
				return "Play BGM: #{parseAudio(@parameters[0])}"
			when 242 #"Fadeout BGM",
				return "Fade-Out BGM: #{@parameters[0]} Seconds"
			when 243 #"Save BGM",
				return "Retain BGM"
			when 244 #"Resume BGM",
				return "Resume BGM"
			when 245 #"Play BGS",
				return "Play BGS: #{parseAudio(@parameters[0])}"
			when 246 #"Fadeout BGS",
				return "Fade-Out BGS: #{@parameters[0]} Seconds"
			when 249 #"Play ME",
				return "Play ME: #{parseAudio(@parameters[0])}"
			when 250 #"Play SE",
				return "Play SE: #{parseAudio(@parameters[0])}"
			when 251 #"Stop SE",
				return "Stop SE"
			when 261 #"Play Movie",
				return "Play Movie: '#{@parameters[0]}'"
			when 281 #"Change Map Name Display",
				return "Change Map Name Display: #{parseSwitch(@parameters[0])}"
			when 282 #"Change Tileset",
				return "Change Tileset: #{getTileset(@parameters[0])}"
			when 283 #"Change Battle Background",
				return "Change Battleback: #{@parameters[0]} & #{@parameters[1]}"
			when 284 #"Change Parallax Background",
				return "Change Parallax Background: #{parseImage(@parameters[0])}"
			when 285 #"Get Location Info",
				s = @parameters[2] == 0 ? parsePosition(@parameters[3], @parameters[4]) : parseVariable2(@parameters[3], @parameters[4])
				return "Acquire Position Information: [#{padVariable(@parameters[0])}], #{parseTypeInfo(@parameters[1])}, #{s}"
			when 301 #"Battle Processing",
				return "Battle Processing: #{@parameters[0] == 2 ? "Same as Random Encounter" : @parameters[0] == 1 ? getVariable(@parameters[1]) : getTroop(@parameters[1])}"
			when 302 #"Shop Processing",
				return "Shop Processing: #{parseShopItem(@parameters[0], @parameters[1])}"
			when 303 #"Name Input Processing",
				return "Name Input Processing: #{getActor(@parameters[0], false)}, #{@parameters[1]} Characters"
			when 311 #"Change HP",
				return "Change HP: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{parseValue(@parameters[3], @parameters[4])}"
			when 312 #"Change MP",
				return "Change MP: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{parseValue(@parameters[3], @parameters[4])}"
			when 313 #"Change State",
				return "Change State: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{getState(@parameters[3])}"
			when 314 #"Recover All",
				return "Full Recovery: #{parseTarget(@parameters[0], @parameters[1])}"
			when 315 #"Change EXP",
				return "Change Experience: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{parseValue(@parameters[3], @parameters[4])}"
			when 316 #"Change Level",
				return "Change Level: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{parseValue(@parameters[3], @parameters[4])}"
			when 317 #"Change Parameters",
				return "Change Parameter: #{parseTarget(@parameters[0], @parameters[1])}, #{parseState(@parameters[2])} #{parseOperation(@parameters[3])} #{parseValue(@parameters[4], @parameters[5])}"
			when 318 #"Change Skills",
				return "Change Skill: #{parseTarget(@parameters[0], @parameters[1])}, #{parseOperation(@parameters[2])} #{getSkill(@parameters[3])}"
			when 319 #"Change Equipment",
				return "Change Equipment: #{getActor(@parameters[0])}, #{parseEquip(@parameters[1], @parameters[2])}"
			when 320 #"Change Name",
				return "Change Name: #{getActor(@parameters[0])}, '#{@parameters[1]}'"
			when 321 #"Change Class",
				return "Change Class: #{getActor(@parameters[0])}, #{getClass(@parameters[1])}"
			when 322 #"Change Actor Graphic",
				return "Change Actor Graphic: #{getActor(@parameters[0])}, #{parseImage(@parameters[1], @parameters[2])}, #{parseImage(@parameters[3], @parameters[4])}"
			when 323 #"Change Vehicle Graphic",
				return "Change Vehicle Graphic: #{parseVehicle(@parameters[0])}, #{parseImage(@parameters[1], @parameters[2])}"
			when 324 #"Change Nickname",
				return "Change Nickname: #{getActor(@parameters[0])}, '#{@parameters[1]}'"
			when 331 #"Change Enemy HP",
				return "Change Enemy HP: #{parseActor(0, @parameters[0])}, #{parseOperation(@parameters[1])} #{parseValue(@parameters[2], @parameters[3])}"
			when 332 #"Change Enemy MP",
				return "Change Enemy MP: #{parseActor(0, @parameters[0])}, #{parseOperation(@parameters[1])} #{parseValue(@parameters[2], @parameters[3])}"
			when 333 #"Change Enemy State",
				return "Change Enemy State: #{parseActor(0, @parameters[0])}, #{parseOperation(@parameters[1])} #{getState(@parameters[2])}"
			when 334 #"Enemy Recover All",
				return "Full Recovery of Enemy: #{parseActor(0, @parameters[0])}"
			when 335 #"Enemy Appear",
				return "Display Hidden Enemy: #{parseActor(0, @parameters[0])}"
			when 336 #"Enemy Transform",
				return "Transform Enemy: #{parseActor(0, @parameters[0])}, #{getEnemy(@parameters[1])}"
			when 337 #"Show Battle Animation",
				return "Display Battle Animation: #{parseActor(0, @parameters[0])}, #{getAnimation(@parameters[1])}"
			when 339 #"Force Action",
				return "Force Battle Action: #{parseActor(@parameters[0], @parameters[1])}, #{getSkill(@parameters[2])}, #{parseActionTarget(@parameters[3])}"
			when 340 #"Abort Battle",
				return "End Battle"
			when 351 #"Open Menu Screen",
				return "Open Menu Screen"
			when 352 #"Open Save Screen",
				return "Open Save Screen"
			when 353 #"Game Over",
				return "Game Over"
			when 354 #"Return to Title Screen",
				return "Return to Title Screen"
			when 355 #"Script",
				return "Script: #{@parameters[0]}"
			when 356 #"Plugin Command",
				return "Plugin Command: #{@parameters[0]}"	
			when 401 #"Show Text - Text Data",
				return "\t#{@parameters[0]}"
			when 402 #"When [**]",
				return "When [#{@parameters[1]}]"
			when 403 #"When Cancel",
				return "When Canceled"
			when 404 # Branch End
				return "Branch End"
			when 405 # Scrolling Text Text
				return "\t#{@parameters[0]}"
			when 408 #"Choice Item",
				return "\t#{@parameters[0]}"
			when 411 #"Else",
				return "Else"
			when 412 #"Branch End",
				return "Branch End"
			when 413 #"Repeat Above",
				return "Repeat Above"
			when 505 #"Moving Route (Moving Method)",
				raise "Given event is not a RPG::MoveCommand, its class is: #{@parameters[0].class}" unless @parameters[0].class == RPG::MoveCommand || @parameters[0].class.superclass == RPG::MoveCommand
				return @parameters[0].to_s
			when 601 #"If Win",
				return "If Party Wins"
			when 602 #"If Escape",
				return "If Party Escapes"
			when 603 #"If Lose"
				return "If Party Loses"
			when 604 #"Branch End",
				return "Branch End"
			when 605 #"Shop Processing Entry",
				return parseShopItem(@parameters[0], @parameters[1])
			when 655 #"Script entry",
				return @parameters[0]
		end
		return ""
	end

	def to_json(*a)
		return {
			"code" => @code,
			"indent" => @indent,
			"parameters" => @parameters
		}.to_json(*a)
	end

	attr_accessor :code
	attr_accessor :indent
	attr_accessor :parameters
end
