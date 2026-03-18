require_relative 'weapon'

class RPG::WeaponMV < RPG::Weapon
	def initialize(json)
		super(json)
	end

	def wtypeId
		@wtype_id
	end

	def animationId
		@animation_id
	end
end