require_relative 'item'

class RPG::ItemMV < RPG::Item
	def initialize(json)
		super(json)
	end

	def itypeId
		@itype_id
	end
end
