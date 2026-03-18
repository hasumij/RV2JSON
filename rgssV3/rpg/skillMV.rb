require_relative 'skill'

class RPG::SkillMV < RPG::Skill
	def initialize(json)
		super(json)
	end

	def stypeId
		@stype_id
	end

	def mpCost
		@mp_cost
	end

	def tpCost
		@tp_cost
	end

	def requiredWtypeId1
		@required_wtype_id1
	end

	def requiredWtypeId2
		@required_wtype_id2
	end
end
