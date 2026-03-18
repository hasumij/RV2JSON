require_relative 'baseItemMV'

class RPG::StateMV < RPG::BaseItemMV
	def initialize(json)
		super(json)
		@restriction = json["restriction"]
		@priority = json["priority"]
		@remove_at_battle_end = json["removeAtBattleEnd"]
		@remove_by_restriction = json["removeByRestriction"]
		@auto_removal_timing = json["autoRemovalTiming"]
		@min_turns = json["minTurns"]
		@max_turns = json["maxTurns"]
		@remove_by_damage = json["removeByDamage"]
		@chance_by_damage = json["chanceByDamage"]
		@remove_by_walking = json["removeByWalking"]
		@steps_to_remove = json["stepsToRemove"]
		@releaseByDamage = json["releaseByDamage"]
		@message1 = json["message1"]
		@message2 = json["message2"]
		@message3 = json["message3"]
		@message4 = json["message4"]
		@motion = json["motion"]
		@overlay = json["overlay"]
		@description = json["description"]
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
		s = "State: #{padVariable(@id, 3)}\n"
		s << super
		s << "Action Restrictions: #{parseRestriction(@restriction)}\n"
		s << "Display Priority: #{@priority}\n"
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
		s << "Remove at Battle End\n" if @remove_at_battle_end
		s << "Clear Action Restrictions\n" if @remove_by_restriction
		s << "Automatic Timed Release: #{parseAutoRelease(@auto_removal_timing)}\n"
		s << "Number of Turns Taken: #{@min_turns} ~ #{@max_turns}\n" unless @auto_removal_timing == 0
		s << "Remove by Damage: #{@chance_by_damage}%\n" if @remove_by_damage
		s << "Remove by Walking: #{@steps_to_remove} Steps\n" if @remove_by_walking
		s << "Inflicted Ally Message: #{@message1}\n" unless @message1.empty?
		s << "Inflicted Enemy Message: #{@message2}\n" unless @message2.empty?
		s << "Continued Infliction Message: #{@message3}\n" unless @message3.empty?
		s << "Recovery Message: #{@message4}\n" unless @message4.empty?
		return s
	end

	attr_accessor :restriction
	attr_accessor :priority
	attr_accessor :remove_at_battle_end
	attr_accessor :remove_by_restriction
	attr_accessor :auto_removal_timing
	attr_accessor :min_turns
	attr_accessor :max_turns
	attr_accessor :remove_by_damage
	attr_accessor :chance_by_damage
	attr_accessor :remove_by_walking
	attr_accessor :steps_to_remove
	attr_accessor :releaseByDamage
	attr_accessor :message1
	attr_accessor :message2
	attr_accessor :message3
	attr_accessor :message4
	attr_accessor :motion
	attr_accessor :overlay
end