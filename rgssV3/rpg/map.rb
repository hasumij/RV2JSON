# TODO: Review and compare to engine

class RPG::Map
	def initialize(width = 0, height = 0)
		@display_name = ''
		@tileset_id = 1
		@width = width
		@height = height
		@scroll_type = 0
		@specify_battleback = false
		@battleback_floor_name = ''
		@battleback_wall_name = ''
		@autoplay_bgm = false
		@bgm = RPG::BGM.new
		@autoplay_bgs = false
		@bgs = RPG::BGS.new('', 80)
		@disable_dashing = false
		@encounter_list = []
		@encounter_step = 30
		@parallax_name = ''
		@parallax_loop_x = false
		@parallax_loop_y = false
		@parallax_sx = 0
		@parallax_sy = 0
		@parallax_show = false
		@note = ''
		@data = Table.new(width, height, 4)
		@events = {}
	end

	def updateFromJson(json)
		@display_name = json["displayName"].encode(@display_name.encoding) if json["displayName"]
		@tileset_id = json["tilesetId"] if json["tilesetId"]
		@width = json["width"] if json["width"]
		@height = json["height"] if json["height"]
		@scroll_type = json["scrollType"] if json["scrollType"]
		@specify_battleback = json["specifyBattleback"] if json["specifyBattleback"]
		@battleback_floor_name = json["battleback1Name"].encode(@battleback_floor_name.encoding) if json["battleback1Name"]
		@battleback_wall_name = json["battleback2Name"].encode(@battleback_wall_name.encoding) if json["battleback2Name"]
		@autoplay_bgm = json["autoplayBgm"] if json["autoplayBgm"]
		@bgm.updateFromJson(json["bgm"]) if json["bgm"]
		@autoplay_bgs = json["autoplayBgs"] if json["autoplayBgs"]
		@bgs.updateFromJson(json["bgs"]) if json["bgs"]
		@disable_dashing = json["disableDashing"] if json["disableDashing"]
		@encounter_step = json["encounterStep"] if json["encounterStep"]
		@parallax_name = json["parallaxName"].encode(@parallax_name.encoding) if json["parallaxName"]
		@parallax_loop_x = json["parallaxLoopX"] if json["parallaxLoopX"]
		@parallax_loop_y = json["parallaxLoopY"] if json["parallaxLoopY"]
		@parallax_sx = json["parallaxSx"] if json["parallaxSx"]
		@parallax_sy = json["parallaxSy"] if json["parallaxSy"]
		@parallax_show = json["parallaxShow"] if json["parallaxShow"]
		@note = json["note"].encode(@note.encoding) if json["note"]
		# @data = json["data"]

		@events.each do |k, v|
			jsonEvent = json["events"].find { |e| e["id"] == k }
			v.updateFromJson(jsonEvent) if jsonEvent
		end
	end


	def to_s
		s = ""
		s << "Display Name: #{@display_name}\n"
		s << "Tileset ID: #{@tileset_id}\n"
		s << "Width: #{@width}\n"
		s << "Height: #{@height}\n"
		s << "Scroll Type: #{@scroll_type}\n"
		s << "Specify Battleback: #{@specify_battleback}\n"
		s << "Battleback Floor Name: #{@battleback_floor_name}\n"
		s << "Battleback Wall Name: #{@battleback_wall_name}\n"
		s << "Autoplay BGM: #{@autoplay_bgm}\n"
		s << "BGM: #{@bgm.to_s}\n"
		s << "Autoplay BGS: #{@autoplay_bgs}\n"
		s << "BGS: #{@bgs.to_s}\n"
		s << "Disable Dashing: #{@disable_dashing}\n"
		s << "Encounter:\n"
		@encounter_list.each { |e| s << e.to_s }
		s << "Encounter Step: #{@encounter_step}\n"
		s << "Parallax Name: #{@parallax_name}\n"
		s << "Parallax Loop X: #{@parallax_loop_x}\n"
		s << "Parallax Loop Y: #{@parallax_loop_y}\n"
		s << "Parallax SW: #{@parallax_sx}\n"
		s << "Parallax SY: #{@parallax_sy}\n"
		s << "Parallax Show: #{@parallax_show}\n"
		s << "Note: #{@note}\n"
		s << "Events:\n"
		@events.each { |i,e| s << e.to_s << "\n" }
		return s
	end

	def to_json(*a)
		return {
			"autoplayBgm" => @autoplay_bgm,
			"autoplayBgs" => @autoplay_bgs,
			"battleback1Name" => @battleback_floor_name,
			"battleback2Name" => @battleback_wall_name,
			"bgm" => @bgm,
			"bgs" => @bgs,
			"disableDashing" => @disable_dashing,
			"displayName" => @display_name,
			"encounterList" => @encounter_list,
			"encounterStep" => @encounter_step,
			"height" => @height,
			"note" => @note,
			"parallaxLoopX" => @parallax_loop_x,
			"parallaxLoopY" => @parallax_loop_y,
			"parallaxName" => @parallax_name,
			"parallaxShow" => @parallax_show,
			"parallaxSx" => @parallax_sx,
			"parallaxSy" => @parallax_sy,
			"scrollType" => @scroll_type,
			"specifyBattleback" => @specify_battleback,
			"tilesetId" => @tileset_id,
			"width" => @width,
			"data" => @data,
			"events" => @events.values
		}.to_json(*a)
	end

	def ==(obj)
		return false unless obj
		return false unless @display_name == obj.display_name
		return false unless @tileset_id == obj.tileset_id
		return false unless @width == obj.width
		return false unless @height == obj.height
		return false unless @scroll_type == obj.scroll_type
		return false unless @specify_battleback == obj.specify_battleback
		return false unless @battleback1_name == obj.battleback1_name
		return false unless @battleback2_name == obj.battleback2_name
		return false unless @autoplay_bgm == obj.autoplay_bgm
		return false unless @bgm == obj.bgm
		return false unless @autoplay_bgs == obj.autoplay_bgs
		return false unless @bgs == obj.bgs
		return false unless @disable_dashing == obj.disable_dashing
		return false unless @encounter_list == obj.encounter_list
		return false unless @encounter_step == obj.encounter_step
		return false unless @parallax_name == obj.parallax_name
		return false unless @parallax_loop_x == obj.parallax_loop_x
		return false unless @parallax_loop_y == obj.parallax_loop_y
		return false unless @parallax_sx == obj.parallax_sx
		return false unless @parallax_sy == obj.parallax_sy
		return false unless @parallax_show == obj.parallax_show
		return false unless @note == obj.note
		return false unless @data == obj.data
		return false unless @events == obj.events
		return true
	end

	attr_accessor :display_name
	attr_accessor :tileset_id
	attr_accessor :width
	attr_accessor :height
	attr_accessor :scroll_type
	attr_accessor :specify_battleback
	attr_accessor :battleback1_name
	attr_accessor :battleback2_name
	attr_accessor :autoplay_bgm
	attr_accessor :bgm
	attr_accessor :autoplay_bgs
	attr_accessor :bgs
	attr_accessor :disable_dashing
	attr_accessor :encounter_list
	attr_accessor :encounter_step
	attr_accessor :parallax_name
	attr_accessor :parallax_loop_x
	attr_accessor :parallax_loop_y
	attr_accessor :parallax_sx
	attr_accessor :parallax_sy
	attr_accessor :parallax_show
	attr_accessor :note
	attr_accessor :data
	attr_accessor :events
end

class RPG::Map::Encounter
	def initialize
		@troop_id = 1
		@weight = 10
		@region_set = []
	end

	def initialize(json)
		@troop_id = json["troopId"]
		@weight = json["weight"]
		@region_set = json["regionSet"]
	end

	def updateFromJson(json)
		@troop_id = json["troopId"] if json["troopId"]
		@weight = json["weight"] if json["weight"]
		@region_set = json["regionSet"] if json["regionSet"]
	end

	def ==(obj)
		return false unless obj
		return false unless @troop_id == obj.troop_id
		return false unless @weight == obj.weight
		return false unless @region_set == obj.region_set
		return true
	end

	def to_s
		s = ""
		s << "Troop ID: #{@troop_id}\n"
		s << "Weight: #{@weight}\n"
		s << "Region Set: #{@region_set}\n"
		return s
	end

	def to_json(*a)
		return {
			"regionSet" => @region_set,
			"troopId" => @troop_id,
			"weight" => @weight
		}.to_json(*a) if @troop_id
	end

	attr_accessor :troop_id
	attr_accessor :weight
	attr_accessor :region_set
end