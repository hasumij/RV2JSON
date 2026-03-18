require_relative 'map'
require_relative 'eventMV'

class RPG::MapMV < RPG::Map
	def initialize(json)
		super()
		@display_name = json["displayName"]
		@tileset_id = json["tilesetId"]
		@width = json["width"]
		@height = json["height"]
		@scroll_type = json["scrollType"]
		@specify_battleback = json["specifyBattleback"]
		@battleback_floor_name = json["battleback1Name"]
		@battleback_wall_name = json["battleback2Name"]
		@autoplay_bgm = json["autoplayBgm"]
		@bgm = RPG::BGMMV.new(json["bgm"])
		@autoplay_bgs = json["autoplayBgs"]
		@bgs = RPG::BGSMV.new(json["bgs"])
		@disable_dashing = json["disableDashing"]
		@encounter_step = json["encounterStep"]
		@parallax_name = json["parallaxName"]
		@parallax_loop_x = json["parallaxLoopX"]
		@parallax_loop_y = json["parallaxLoopY"]
		@parallax_sx = json["parallaxSx"]
		@parallax_sy = json["parallaxSy"]
		@parallax_show = json["parallaxShow"]
		@note = json["note"]
		@encounter_list = json["encounterList"].map { |e| RPG::MapMV::EncounterMV.new(e) }
		@data = json["data"]
		@events = {}

		json["events"].each_with_index do |e, i|
			if e
				@events[i] = RPG::EventMV.new(e)
			else
				@events[i] = nil
			end
		end
	end

	def displayName
		@display_name
	end

	def tilesetId
		@tileset_id
	end

	def scrollType
		@scroll_type
	end

	def specifyBattleback
		@specify_battleback
	end

	def battleback1Name
		@battleback_floor_name
	end

	def battleback2Name
		@battleback_wall_name
	end

	def autoplayBgm
		@autoplay_bgm
	end

	def autoplayBgs
		@autoplay_bgs
	end

	def disableDashing
		@disable_dashing
	end

	def encounterStep
		@encounter_step
	end

	def parallaxName
		@parallax_name
	end

	def parallaxLoopX
		@parallax_loop_x
	end

	def parallaxLoopY
		@parallax_loop_y
	end

	def parallaxSx
		@parallax_sx
	end

	def parallaxSy
		@parallax_sy
	end

	def parallaxShow
		@parallax_show
	end

	def encounterList
		@encounter_list
	end
end

class RPG::MapMV::EncounterMV < RPG::Map::Encounter
	def initialize(json)
		super()
		@troop_id = json["troopId"]
		@weight = json["weight"]
		@region_set = json["regionSet"]
	end

	def troopId
		@troop_id
	end

	def regionSet
		@region_set
	end
end