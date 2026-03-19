require_relative 'mapInfo'

class RPG::MapInfoMV < RPG::MapInfo
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
