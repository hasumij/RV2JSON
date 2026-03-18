require_relative 'usableItemMV'

class RPG::SkillMV < RPG::UsableItemMV
	def initialize(json)
		super(json)
		@stype_id = json["stypeId"]
		@mp_cost = json["mpCost"]
		@tp_cost = json["tpCost"]
		@message1 = json["message1"]
		@message2 = json["message2"]
		@required_wtype_id1 = json["requiredWtypeId1"]
		@required_wtype_id2 = json["requiredWtypeId2"]
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

	def to_s
		s = "Skill: #{padVariable(@id, 3)}\n"
		s << super
		s << "Skill Type: #{getSkillType(@stype_id)}\n"
		s << "MP Cost: #{@mp_cost}\n"
		s << "TP Cost: #{@tp_cost}\n"
		s << "Action Message: #{@message1}\n"
		s << "Action Message 2: #{@message2}\n" unless @message2.empty?
		s << "Required Weapon Type 1: #{getWeaponType(@required_wtype_id1)}\n"
		s << "Required Weapon Type 2: #{getWeaponType(@required_wtype_id2)}\n"
		return s
	end

	attr_accessor :stype_id
	attr_accessor :mp_cost
	attr_accessor :tp_cost
	attr_accessor :message1
	attr_accessor :message2
	attr_accessor :required_wtype_id1
	attr_accessor :required_wtype_id2
end
