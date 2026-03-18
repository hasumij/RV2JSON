require_relative 'class'

class RPG::ClassMV < RPG::Class
	def initialize(json)
		super(json)
	end

	def expParams
		@exp_params
	end
end

class RPG::ClassMV::LearningMV < RPG::Class::Learning
	def initialize(json)
		super(json)
	end

	def skillId
		@skill_id
	end
end
