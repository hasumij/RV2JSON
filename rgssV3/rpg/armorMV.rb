require_relative 'equipItemMV'

class RPG::ArmorMV < RPG::EquipItemMV
	def initialize(json)
		super(json)
		@atype_id = json["atypeId"]
		@etype_id = json["etypeId"]
	end

	def atypeId
		@atype_id
	end

	def etypeId
		@etype_id
	end

	def to_s
		s = "Armor: #{padVariable(@id, 3)}\n"
		s << super
		s << "Armor Type: #{getArmorType(@atype_id)}\n"
		return s
	end

	attr_accessor :atype_id
end