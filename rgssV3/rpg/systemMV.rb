require_relative 'system'
require_relative 'audioFileMV'

class RPG::SystemMV < RPG::System
	def initialize(json)
		super()
		@game_title = json["gameTitle"]
		@version_id = json["versionId"]
		@japanese = json["locale"] == "ja_JP"
		@locale = json["locale"]
		@party_members = json["partyMembers"]
		@currency_unit = json["currencyUnit"]
		@elements = json["elements"]
		@skill_types = json["skillTypes"]
		@weapon_types = json["weaponTypes"]
		@armor_types = json["armorTypes"]
		@switches = json["switches"]
		@variables = json["variables"]
		@boat = RPG::SystemMV::VehicleMV.new(json["boat"])
		@ship = RPG::SystemMV::VehicleMV.new(json["ship"])
		@airship = RPG::SystemMV::VehicleMV.new(json["airship"])
		@title1_name = json["title1Name"]
		@title2_name = json["title2Name"]
		@opt_draw_title = json["optDrawTitle"]
		@opt_use_midi = false # Not present in MV
		@optSideView = json["optSideView"]
		@opt_transparent = json["optTransparent"]
		@opt_followers = json["optFollowers"]
		@opt_slip_death = json["optSlipDeath"]
		@opt_floor_death = json["optFloorDeath"]
		@opt_display_tp = json["optDisplayTp"]
		@opt_extra_exp = json["optExtraExp"]
		@window_tone = Tone.new(json["windowTone"][0],json["windowTone"][1],json["windowTone"][2],json["windowTone"][3])
		@title_bgm = RPG::BGMMV.new(json["titleBgm"])
		@battle_bgm = RPG::BGMMV.new(json["battleBgm"])
		@battle_end_me = RPG::MEMV.new(json["victoryMe"])
		@defeatMe = RPG::MEMV.new(json["defeatMe"])
		@gameover_me = RPG::MEMV.new(json["gameoverMe"])
		@test_troop_id = json["testTroopId"]
		@start_map_id = json["startMapId"]
		@start_x = json["startX"]
		@start_y = json["startY"]
		@battleback1_name = json["battleback1Name"]
		@battleback2_name = json["battleback2Name"]
		@battler_name = json["battlerName"]
		@battler_hue = json["battlerHue"]
		@edit_map_id = json["editMapId"]

		@menuCommands = json["menuCommands"]
		@magicSkills = json["magicSkills"]
		@attackMotions = json["attackMotions"].map { |a| RPG::SystemMV::AttackMotion.new(a) }

		@test_battlers = json["testBattlers"].map { |t| RPG::SystemMV::TestBattlerMV.new(t) }
	
		@equipTypes = json["equipTypes"]
		@sounds = json["sounds"].map { |s| RPG::SEMV.new(s) }
		@terms = RPG::SystemMV::TermsMV.new(json["terms"])

		@hasEncryptedImages = false
		@hasEncryptedAudio  = false
		@encryptionKey      = ""

		@hasEncryptedImages = json["hasEncryptedImages"] if json.key?("hasEncryptedImages")
		@hasEncryptedAudio  = json["hasEncryptedAudio"] if json.key?("hasEncryptedAudio")
		@encryptionKey      = json["encryptionKey"] if json.key?("encryptionKey")
	end

	def gameTitle
		@game_title
	end

	def versionId
		@version_id
	end

	def partyMembers
		@party_members
	end

	def currencyUnit
		@currency_unit
	end

	def skillTypes
		@skill_types
	end

	def weaponTypes
		@weapon_types
	end

	def armorTypes
		@armor_types
	end

	def title1Name
		@title1_name
	end

	def title2Name
		@title2_name
	end

	def optDrawTitle
		@opt_draw_title
	end

	def optTransparent
		@opt_transparent
	end

	def optFollowers
		@opt_followers
	end

	def optSlipDeath
		@opt_slip_death
	end

	def optFloorDeath
		@opt_floor_death
	end

	def optDisplayTp
		@opt_display_tp
	end

	def optExtraExp
		@opt_extra_exp
	end

	def windowTone
		@window_tone
	end

	def titleBgm
		@title_bgm
	end

	def battleBgm
		@battle_bgm
	end

	def victoryMe
		@battle_end_me
	end

	def gameoverMe
		@gameover_me
	end

	def testTroopId
		@test_troop_id
	end

	def startMapId
		@start_map_id
	end

	def startX
		@start_x
	end

	def startY
		@start_y
	end

	def battleback1Name
		@battleback1_name
	end

	def battleback2Name
		@battleback2_name
	end

	def battlerName
		@battler_name
	end

	def battlerHue
		@battler_hue
	end

	def editMapId
		@edit_map_id
	end

	def testBattlers
		@test_battlers
	end

	def to_s
		s = super()
		s << "\nArmor Types:\n"
		@equipTypes.each_with_index { |e,i| s << "#{padVariable(i, @equipTypes.size.to_s.size)}#{e.empty? ? "" : ":#{e}"}\n" if e && i > 0 }

		s << "\nUse Side-view Battle" if @optSideView
		s << "\nDefeat ME:\n#{@defeatMe.to_s}" if @defeatMe
		s << "\nMenu Commands:\n"
		s << "Item\n" if @menuCommands[0]
		s << "Skill\n" if @menuCommands[1]
		s << "Equip\n" if @menuCommands[2]
		s << "Status\n" if @menuCommands[3]
		s << "Formation\n" if @menuCommands[4]
		s << "Save\n" if @menuCommands[5]

		s << "\n[SV] Magic Skills:\n"
		magicSkills.each { |m| s << getSkillType(m) }
		s << "\n"

		s << "\n[SV] Attack Motions:\n"
		attackMotions.each { |a| s << a.to_s }
		s << "\n"
	end

	def to_json(*a)
		return super().merge!({
			"equipTypes" => @equipTypes,
			"menuCommands" => @menuCommands,
			"magicSkills" => @magicSkills,
			"attackMotions" => @attackMotions,
			"optSideView" => @optSideView,
			"defeatMe" => @defeatMe,
			"locale" => @locale,
			"hasEncryptedImages" => @hasEncryptedImages,
			"hasEncryptedAudio" => @hasEncryptedAudio,
			"encryptionKey" => @encryptionKey
		}.to_json(*a))
	end

	attr_accessor :equipTypes
	attr_accessor :menuCommands
	attr_accessor :magicSkills
	attr_accessor :attackMotions
	attr_accessor :optSideView
	attr_accessor :defeatMe
	attr_accessor :locale
	attr_accessor :hasEncryptedImages
	attr_accessor :hasEncryptedAudio
	attr_accessor :encryptionKey
end

class RPG::SystemMV::AttackMotion
	def initialize(json)
		@type = json["type"]
		@weaponImageId = json["weaponImageId"]
	end

	def to_s
		s = ""
		s << case @type
			when 0; "Thrust"
			when 1; "Swing"
			when 2; "Missile"
		end
		s << " "
		s << case @weaponImageId
			when  0; "None"
			when  1; "Dagger"
			when  2; "Sword"
			when  3; "Flail"
			when  4; "Axe"
			when  5; "Whip"
			when  6; "Cane"
			when  7; "Bow"
			when  8; "Crossbow"
			when  9; "Gun"
			when 10; "Claw"
			when 11; "Glove"
			when 12; "Spear"
			when 13; "Mace"
			when 14; "Rod"
			when 15; "Club"
			when 16; "Combat Chain"
			when 17; "Futuristic Sword"
			when 18; "Iron pipe"
			when 19; "Slingshot"
			when 20; "Shotgun"
			when 21; "Rifle"
			when 22; "Chainsaw"
			when 23; "Railgun"
			when 24; "Stun Rod"
			when 25; "User-defined 1"
			when 26; "User-defined 2"
			when 27; "User-defined 3"
			when 28; "User-defined 4"
			when 29; "User-defined 5"
			when 30; "User-defined 6"
		end
		s << "\n"
		return s
	end

	def to_json(*a)
		return {
			"type" => @type,
			"weaponImageId" => @weaponImageId
		}.to_json(*a)
	end

	attr_accessor :type
	attr_accessor :weaponImageId
end

class RPG::SystemMV::VehicleMV < RPG::System::Vehicle
	def initialize(json)
		super()
		@character_name = json["characterName"]
		@character_index = json["characterIndex"]
		@bgm = RPG::BGMMV.new(json["bgm"])
		@start_map_id = json["startMapId"]
		@start_x = json["startX"]
		@start_y = json["startY"]
	end

	def characterName
		@character_name
	end

	def characterIndex
		@character_index
	end

	def startMapId
		@start_map_id
	end
end

class RPG::SystemMV::TermsMV < RPG::System::Terms
	def initialize(json)
		super()
		@basic = json["basic"]
		@params = json["params"]
		@etypes = []
		@commands = json["commands"]
		@messages = json["messages"]
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
		s << "EXP: #{@basic[7]}\n"
		s << "EXP (Abbreviated): #{@basic[8]}\n"

		s << "\nParameters:\n"
		s << "Maximum HP: #{params[0]}\n"
		s << "Maximum MP: #{params[1]}\n"
		s << "Attack: #{params[2]}\n"
		s << "Defense: #{params[3]}\n"
		s << "Magic: #{params[4]}\n"
		s << "Magic Defense: #{params[5]}\n"
		s << "Agility: #{params[6]}\n"
		s << "Luck: #{params[7]}\n"
		s << "Hit Rate: #{params[8]}\n"
		s << "Evasion Rate: #{params[9]}\n"

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
		s << "Options: #{@commands[11]}\n"
		s << "Save: #{@commands[9]}\n"
		s << "Game End: #{@commands[10]}\n"
		s << "Weapons: #{@commands[12]}\n"
		s << "Armors: #{@commands[13]}\n"
		s << "Key Items: #{@commands[14]}\n"
		s << "Change Equipment: #{@commands[15]}\n"
		s << "Optimize: #{@commands[16]}\n"
		s << "Remove All: #{@commands[17]}\n"
		s << "Buy: #{@commands[24]}\n"
		s << "Sell: #{@commands[25]}\n"
		s << "New Game: #{@commands[18]}\n"
		s << "Continue: #{@commands[19]}\n"
		s << "To Title: #{@commands[21]}\n"
		s << "Cancel: #{@commands[22]}\n"
		s << "\n"
		@messages.each { |k,v| s << "#{k}: #{v}\n" }
		return s
	end

	attr_accessor :messages
end

class RPG::SystemMV::TestBattlerMV < RPG::System::TestBattler
	def initialize(json)
		super()
		@actor_id = json["actorId"]
		@level = json["level"]
		@equips = json["equips"]
	end

	def actorId
		@actor_id
	end
end
