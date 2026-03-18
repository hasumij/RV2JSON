require_relative 'armor'

class RPG::ArmorMV < RPG::Armor
	def initialize(json)
		super(json)
	end

	def atypeId
		@atype_id
	end

	def etypeId
		@etype_id
	end
end