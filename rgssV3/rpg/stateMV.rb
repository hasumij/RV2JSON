require_relative 'state'

class RPG::StateMV < RPG::State
	def initialize(json)
		super(json)
		@releaseByDamage = json["releaseByDamage"]
		@motion = json["motion"]
		@overlay = json["overlay"]
	end

	def removeAtBattleEnd
		@remove_at_battle_end
	end

	def removeByRestriction
		@remove_by_restriction
	end

	def autoRemovalTiming
		@auto_removal_timing
	end

	def minTurns
		@min_turns
	end

	def maxTurns
		@max_turns
	end

	def removeByDamage
		@remove_by_damage
	end

	def chanceByDamage
		@chance_by_damage
	end

	def removeByWalking
		@remove_by_walking
	end

	def stepsToRemove
		@steps_to_remove
	end


	def to_s
		s << super
		s << "[SV] Motion: "
		s << case @motion
			when 0; "Normal\n"
			when 1; "Abnormal\n"
			when 2; "Sleep\n"
			when 3; "Dead\n"
		end
		s << "[SV] Overlay: "
		s << case @overlay
			when  0; "None\n"
			when  1; "Poison\n"
			when  2; "Blind\n"
			when  3; "Silence\n"
			when  4; "Rage\n"
			when  5; "Confusion\n"
			when  6; "Fascination\n"
			when  7; "Sleep\n"
			when  8; "Paralyze\n"
			when  9; "Curse\n"
			when 10; "Fear\n"
		end
		return s
	end

	attr_accessor :releaseByDamage
	attr_accessor :motion
	attr_accessor :overlay
end