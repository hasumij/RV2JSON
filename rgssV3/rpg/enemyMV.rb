require_relative 'enemy'

class RPG::EnemyMV < RPG::Enemy
	def initialize(json)
		super(json)
	end

	def battlerName
		@battler_name
	end

	def battlerHue
		@battler_hue
	end

	def dropItems
		@drop_items
	end
end
