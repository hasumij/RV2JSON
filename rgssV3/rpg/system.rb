class RPG::System
	def initialize
		@game_title = ''
		@version_id = 0
		@japanese = true
		@party_members = [1]
		@currency_unit = ''
		@elements = [nil, '']
		@skill_types = [nil, '']
		@weapon_types = [nil, '']
		@armor_types = [nil, '']
		@switches = [nil, '']
		@variables = [nil, '']
		@boat = RPG::System::Vehicle.new
		@ship = RPG::System::Vehicle.new
		@airship = RPG::System::Vehicle.new
		@title1_name = ''
		@title2_name = ''
		@opt_draw_title = true
		@opt_use_midi = false
		@opt_transparent = false
		@opt_followers = true
		@opt_slip_death = false
		@opt_floor_death = false
		@opt_display_tp = true
		@opt_extra_exp = false
		@window_tone = Tone.new(0,0,0)
		@title_bgm = RPG::BGM.new
		@battle_bgm = RPG::BGM.new
		@battle_end_me = RPG::ME.new
		@gameover_me = RPG::ME.new
		@sounds = Array.new(24) { RPG::SE.new }
		@test_battlers = []
		@test_troop_id = 1
		@start_map_id = 1
		@start_x = 0
		@start_y = 0
		@terms = RPG::System::Terms.new
		@battleback1_name = ''
		@battleback2_name = ''
		@battler_name = ''
		@battler_hue = 0
		@edit_map_id = 1
	end

	def updateFromJson(json)
		updateItemFromJson(@game_title, json["gameTitle"])
		updateItemFromJson(@version_id, json["versionId"])
		updateItemFromJson(@party_members, json["partyMembers"])
		updateItemFromJson(@currency_unit, json["currencyUnit"])
		updateItemFromJson(@elements, json["elements"])
		updateItemFromJson(@skill_types, json["skillTypes"])
		updateItemFromJson(@weapon_types, json["weaponTypes"])
		updateItemFromJson(@armor_types, json["armorTypes"])
		updateItemFromJson(@switches, json["switches"])
		updateItemFromJson(@variables, json["variables"])
		updateItemFromJson(@boat, json["boat"])
		updateItemFromJson(@ship, json["ship"])
		updateItemFromJson(@airship, json["airship"])
		updateItemFromJson(@title1_name, json["title1Name"])
		updateItemFromJson(@title2_name, json["title2Name"])
		updateItemFromJson(@opt_draw_title, json["optDrawTitle"])
		updateItemFromJson(@opt_use_midi, json["optUseMidi"])
		updateItemFromJson(@opt_transparent, json["optTransparent"])
		updateItemFromJson(@opt_followers, json["optFollowers"])
		updateItemFromJson(@opt_slip_death, json["optSlipDeath"])
		updateItemFromJson(@opt_floor_death, json["optFloorDeath"])
		updateItemFromJson(@opt_display_tp, json["optDisplayTp"])
		updateItemFromJson(@opt_extra_exp, json["optExtraExp"])

		# @window_tone = json["windowTone"]
		updateItemFromJson(@title_bgm, json["titleBgm"])
		updateItemFromJson(@battle_bgm, json["battleBgm"])
		updateItemFromJson(@battle_end_me, json["victoryMe"])
		updateItemFromJson(@gameover_me, json["gameoverMe"])
		listUpdateFromJson(@sounds, json["sounds"])
		listUpdateFromJson(@test_battlers, json["testBattlers"])

		updateItemFromJson(@terms, json["terms"])
		updateItemFromJson(@battleback1_name, json["battleback1Name"])
		updateItemFromJson(@battleback2_name, json["battleback2Name"])
		updateItemFromJson(@battler_name, json["battlerName"])
		updateItemFromJson(@battler_hue, json["battlerHue"])
		updateItemFromJson(@edit_map_id, json["editMapId"])
	end

	def to_s
		s = ""
		s << "Game Title: #{@game_title}\n"
		s << "Version ID: #{@version_id}\n"
		s << "Japanese: #{@japanese ? "Yes" : "No"}\n"
		s << "Currency Uint: #{@currency_unit}\n"
		s << "Initial Party:\n" unless @party_members.empty?
		@party_members.each { |pm| s << getActor(pm, false) }
		
		s << "\nOptions:\n"
		s << "Initialize MIDI on Startup\n" if @opt_use_midi
		s << "Start Transparent\n" if @opt_transparent
		s << "Show Player Followers\n" if @opt_followers
		s << "K.O. by Slip Damage\n" if @opt_slip_death
		s << "K.O. by Floor Damage\n" if @opt_floor_death
		s << "Display TP in Battle\n" if @opt_display_tp
		s << "EXP for Reserve Members\n" if @opt_extra_exp

		s << "\nMusic:\n"
		s << "Title BGM:\n#{@title_bgm.to_s}" if @title_bgm
		s << "Battle BGM:\n#{@battle_bgm.to_s}" if @battle_bgm
		s << "Battle End ME:\n#{@battle_end_me.to_s}" if @battle_end_me
		s << "Gameover ME:\n#{@gameover_me.to_s}" if @gameover_me
		s << "Boat:\n#{@boat.bgm.to_s}" if @boat
		s << "Ship:\n#{@ship.bgm.to_s}" if @ship
		s << "Airship:\n#{@airship.bgm.to_s}" if @airship

		s << "\nSound Effects:\n"
		@sounds.each_with_index { |e,i| s << e.to_s }

		s << "\nStarting Positions:\n"
		s << "Player: #{parseMapPosition(@start_map_id, @start_x, @start_y)}\n"
		s << "Boat: #{parseMapPosition(@boat.start_map_id, @boat.start_x, @boat.start_y)}\n"
		s << "Ship: #{parseMapPosition(@ship.start_map_id, @ship.start_x, @ship.start_y)}\n"
		s << "Airship: #{parseMapPosition(@airship.start_map_id, @airship.start_x, @airship.start_y)}\n"

		s << "\nTitle Screen:\n"
		s << "Graphic: #{@title1_name}\n" unless @title1_name.empty?
		s << "Graphic 2: #{@title2_name}\n" unless @title2_name.empty?
		s << "Draw Game Title\n" if @opt_draw_title

		s << "\nBattleback 1: #{@battleback1_name}\n"
		s << "Battleback 2: #{@battleback2_name}\n"
		s << "Edit Map: #{getMapName(@edit_map_id)}\n" if @edit_map_id != 0

		s << "\nTerms:\n"
		s << "Attributes:\n"
		@elements.each_with_index { |e,i| s << "#{padVariable(i, @elements.size.to_s.size)}#{e.empty? ? "" : ":#{e}"}\n" if e && i > 0 }
		s << "\nWeapon Types:\n"
		@weapon_types.each_with_index { |e,i| s << "#{padVariable(i, @weapon_types.size.to_s.size)}#{e.empty? ? "" : ":#{e}"}\n" if e && i > 0 }
		s << "\nSkill Types:\n"
		@skill_types.each_with_index { |e,i| s << "#{padVariable(i, @skill_types.size.to_s.size)}#{e.empty? ? "" : ":#{e}"}\n" if e && i > 0 }
		s << "\nArmor Types:\n"
		@armor_types.each_with_index { |e,i| s << "#{padVariable(i, @armor_types.size.to_s.size)}#{e.empty? ? "" : ":#{e}"}\n" if e && i > 0 }

		s << @terms.to_s
		
		s << "\nSwitches:\n"
		@switches.each_with_index { |e,i| s << "#{getSwitch(i)}\n" if e }
		s << "\nVariables:\n"
		@variables.each_with_index { |e,i| s << "#{getVariable(i)}\n" if e }

		return s
	end

	def to_json(*a)
		return {
			"airship" => @airship,
			"armorTypes" => @armor_types,
			"battleBgm" => @battle_bgm,
			"battleback1Name" => @battleback1_name,
			"battleback2Name" => @battleback2_name,
			"battlerHue" => @battler_hue,
			"battlerName" => @battler_name,
			"boat" => @boat,
			"currencyUnit" => @currency_unit,
			"editMapId" => @edit_map_id,
			"elements" => @elements,
			"gameTitle" => @game_title,
			"gameoverMe" => @gameover_me,
			"optDisplayTp" => @opt_display_tp,
			"optDrawTitle" => @opt_draw_title,
			"optExtraExp" => @opt_extra_exp,
			"optFloorDeath" => @opt_floor_death,
			"optFollowers" => @opt_followers,
			"optSlipDeath" => @opt_slip_death,
			"optTransparent" => @opt_transparent,
			"partyMembers" => @party_members,
			"ship" => @ship,
			"skillTypes" => @skill_types,
			"sounds" => @sounds,
			"startMapId" => @start_map_id,
			"startX" => @start_x,
			"startY" => @start_y,
			"switches" => @switches,
			"terms" => @terms,
			"testBattlers" => @test_battlers,
			"testTroopId" => @test_troop_id,
			"title1Name" => @title1_name,
			"title2Name" => @title2_name,
			"titleBgm" => @title_bgm,
			"variables" => @variables,
			"versionId" => @version_id,
			"victoryMe" => @battle_end_me,
			"weaponTypes" => @weapon_types,
			"windowTone" => [@window_tone.red, @window_tone.green, @window_tone.blue, @window_tone.gray]
		}.to_json(*a)
	end

	def namedSwitch?(id)
		return false if @switches.size <= id
		return !(@switches[id].empty?)
	end

	def getSwitchName(id)
		return "" if @switches.size < id
		return @switches[id]
	end


	def namedVariable?(id)
		return false if @variables.size < id
		return !(@variables[id].empty?)
	end

	def getVariableName(id)
		return "" if @variables.size < id
		return @variables[id]
	end

	attr_accessor :game_title
	attr_accessor :version_id
	attr_accessor :japanese
	attr_accessor :party_members
	attr_accessor :currency_unit
	attr_accessor :skill_types
	attr_accessor :weapon_types
	attr_accessor :armor_types
	attr_accessor :elements
	attr_accessor :switches
	attr_accessor :variables
	attr_accessor :boat
	attr_accessor :ship
	attr_accessor :airship
	attr_accessor :title1_name
	attr_accessor :title2_name
	attr_accessor :opt_draw_title
	attr_accessor :opt_use_midi
	attr_accessor :opt_transparent
	attr_accessor :opt_followers
	attr_accessor :opt_slip_death
	attr_accessor :opt_floor_death
	attr_accessor :opt_display_tp
	attr_accessor :opt_extra_exp
	attr_accessor :window_tone
	attr_accessor :title_bgm
	attr_accessor :battle_bgm
	attr_accessor :battle_end_me
	attr_accessor :gameover_me
	attr_accessor :sounds
	attr_accessor :test_battlers
	attr_accessor :test_troop_id
	attr_accessor :start_map_id
	attr_accessor :start_x
	attr_accessor :start_y
	attr_accessor :terms
	attr_accessor :battleback1_name
	attr_accessor :battleback2_name
	attr_accessor :battler_name
	attr_accessor :battler_hue
	attr_accessor :edit_map_id
end

class RPG::System::Vehicle
	def initialize
		@character_name = ''
		@character_index = 0
		@bgm = RPG::BGM.new
		@start_map_id = 0
		@start_x = 0
		@start_y = 0
	end

	def updateFromJson(json)
		updateItemFromJson(@character_name, json["characterName"])
		updateItemFromJson(@character_index, json["characterIndex"])
		updateItemFromJson(@bgm, json["bgm"])
		updateItemFromJson(@start_map_id, json["startMapId"])
		updateItemFromJson(@start_x, json["startX"])
		updateItemFromJson(@start_y, json["startY"])
	end

	def to_s
		s = ""
		s << "Character Name: #{@character_name}\n"
		s << "Character Index: #{@character_index}\n"
		s << "BGM: #{@bgm.to_s}\n"
		s << "Starting Position: #{parseMapPosition(@start_map_id, @start_x, @start_y)}\n"
		return s
	end

	def to_json(*a)
		return {
			"bgm" => @bgm,
			"characterIndex" => @character_index,
			"characterName" => @character_name,
			"startMapId" => @start_map_id,
			"startX" => @start_x,
			"startY" => @start_y
		}.to_json(*a)
	end

	attr_accessor :character_name
	attr_accessor :character_index
	attr_accessor :bgm
	attr_accessor :start_map_id
	attr_accessor :start_x
	attr_accessor :start_y
end

class RPG::System::Terms
	def initialize
		@basic = Array.new(8) {''}
		@params = Array.new(8) {''}
		@etypes = Array.new(5) {''}
		@commands = Array.new(23) {''}
	end

	def updateFromJson(json)
		updateItemFromJson(@basic, json["basic"])
		updateItemFromJson(@params, json["params"])
		updateItemFromJson(@etypes, json["etypes"])
		updateItemFromJson(@commands, json["commands"])
	end

	def to_s
		s = ""
		s << "\nBase Status:\n"
		s << "Level: #{@basic[0]}\n"
		s << "Level (Abbreviated): #{@basic[1]}\n"
		s << "HP: #{@basic[2]}\n"
		s << "HP (Abbreviated): #{@basic[3]}\n"
		s << "MP: #{@basic[4]}\n"
		s << "MP (Abbreviated): #{@basic[5]}\n"
		s << "TP: #{@basic[6]}\n"
		s << "TP (Abbreviated): #{@basic[7]}\n"

		s << "\nParameters:\n"
		s << "Maximum HP: #{params[0]}\n"
		s << "Maximum MP: #{params[1]}\n"
		s << "Attack: #{params[2]}\n"
		s << "Defense: #{params[3]}\n"
		s << "Magic: #{params[4]}\n"
		s << "Magic Defense: #{params[5]}\n"
		s << "Agility: #{params[6]}\n"
		s << "Luck: #{params[7]}\n"

		s << "\nEquipment Types:\n"
		s << "Weapon: #{@etypes[0]}\n"
		s << "Shield: #{@etypes[1]}\n"
		s << "Head: #{@etypes[2]}\n"
		s << "Body: #{@etypes[3]}\n"
		s << "Accessory: #{@etypes[4]}\n"

		s << "\nCommands:\n"
		s << "Fight: #{@commands[0]}\n"
		s << "Escape: #{@commands[1]}\n"
		s << "Attack: #{@commands[2]}\n"
		s << "Guard: #{@commands[3]}\n"
		s << "Items: #{@commands[4]}\n"
		s << "Skills: #{@commands[5]}\n"
		s << "Equipment: #{@commands[6]}\n"
		s << "Status: #{@commands[7]}\n"
		s << "Formation: #{@commands[8]}\n"
		s << "Save: #{@commands[9]}\n"
		s << "Game End: #{@commands[10]}\n"
		s << "Weapons: #{@commands[12]}\n"
		s << "Armors: #{@commands[13]}\n"
		s << "Key Items: #{@commands[14]}\n"
		s << "Change Equipment: #{@commands[15]}\n"
		s << "Equip Best: #{@commands[16]}\n"
		s << "Remove All: #{@commands[17]}\n"
		s << "New Game: #{@commands[18]}\n"
		s << "Continue: #{@commands[19]}\n"
		s << "Shutdown: #{@commands[20]}\n"
		s << "To Title: #{@commands[21]}\n"
		s << "Cancel: #{@commands[22]}\n"
		return s
	end

	def to_json(*a)
		return {
			"basic" => @basic,
			"commands" => @commands,
			"params" => @params,
			"messages" => @messages
		}.to_json(*a)
	end

	attr_accessor :basic
	attr_accessor :params
	attr_accessor :etypes
	attr_accessor :commands
end

class RPG::System::TestBattler
	def initialize
		@actor_id = 1
		@level = 1
		@equips = [0,0,0,0,0]
	end

	def updateFromJson(json)
		updateItemFromJson(@actor_id, json["actorId"])
		updateItemFromJson(@level, json["level"])
		updateItemFromJson(@equips, json["equips"])
	end

	def to_s
		s = ""
		s << "Actor ID:: #{@actor_id}\n"
		s << "Level: #{@level}\n"
		s << "Equips: #{@equips}\n"
		return s
	end

	def to_json(*a)
		return {
			"actorId" => @actor_id,
			"equips" => @equips,
			"level" => @level
		}.to_json(*a)
	end

	attr_accessor :actor_id
	attr_accessor :level
	attr_accessor :equips
end
