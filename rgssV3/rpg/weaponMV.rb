require_relative 'equipItemMV'

class RPG::WeaponMV < RPG::EquipItemMV
	def initialize(json)
		super(json)
		@wtype_id = json["wtypeId"]
		@animation_id = json["animationId"]
	end

	def wtypeId
		@wtype_id
	end

	def animationId
		@animation_id
	end

	def to_s
		s = "Weapon: #{padVariable(@id, 3)}\n"
		s << super
		s << "Weapon Type: #{getWeaponType(@wtype_id)}\n"
		s << "Animation: #{getAnimation(@animation_id, false)}\n"
		return s
	end

	attr_accessor :wtype_id
	attr_accessor :animation_id
end