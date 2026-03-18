require_relative 'mapInfo'

class RPG::MapInfoMV < RPG::MapInfo
	def initialize(json)
		super()
		@name = json["name"]
		@id = json["id"]
		@parent_id = json["parentId"]
		@order = json["order"]
		@expanded	= json["expanded"]
		@scroll_x	= json["scrollX"]
		@scroll_y	= json["scrollY"]
	end

	def parentId
		@parent_id
	end

	def scrollX
		@scroll_x
	end

	def scrollY
		@scroll_y
	end

	attr_accessor :id
end
