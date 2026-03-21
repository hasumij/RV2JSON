require_relative 'usableItem'

class RPG::Skill < RPG::UsableItem
	def initialize
		super
		@scope = 1
		@stype_id = 1
		@mp_cost = 0
		@tp_cost = 0
		@message1 = ''
		@message2 = ''
		@required_wtype_id1 = 0
		@required_wtype_id2 = 0
	end

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

	def updateFromJson(json)
		super(json)
		@scope = json["scope"] if json["scope"]
		@stype_id = json["stypeId"] if json["stypeId"]
		@mp_cost = json["mpCost"] if json["mpCost"]
		@tp_cost = json["tpCost"] if json["tpCost"]
		@message1 = json["message1"].encode(@message1.encoding) if json["message1"]
		@message2 = json["message2"].encode(@message2.encoding) if json["message2"]
		@required_wtype_id1 = json["requiredWtypeId1"] if json["requiredWtypeId1"]
		@required_wtype_id2 = json["requiredWtypeId2"] if json["requiredWtypeId2"]
	end

	def getDiff(obj)
		diffs = super
		diffs << "Type changed" if @stype_id != obj.stype_id
		diffs << "MP Cost changed" if @mp_cost != obj.mp_cost
		diffs << "TP Cost changed" if @tp_cost != obj.tp_cost
		diffs << "Message 1 changed" if @message1 != obj.message1
		diffs << "Message 2 changed" if @message2 != obj.message2
		diffs << "Required Weapon 1 changed" if @required_wtype_id1 != obj.required_wtype_id1
		diffs << "Required Weapon 2 changed" if @required_wtype_id2 != obj.required_wtype_id2
		return diffs
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

	def to_json(*a)
		return {
			"id" => @id,
			"animationId" => @animation_id,
			"damage" => @damage,
			"description" => @description,
			"effects" => @effects,
			"hitType" => @hit_type,
			"iconIndex" => @icon_index,
			"message1" => @message1,
			"message2" => @message2,
			"mpCost" => @mp_cost,
			"name" => @name,
			"note" => @note,
			"occasion" => @occasion,
			"repeats" => @repeats,
			"requiredWtypeId1" => @required_wtype_id1,
			"requiredWtypeId2" => @required_wtype_id2,
			"scope" => @scope,
			"speed" => @speed,
			"stypeId" => @stype_id,
			"successRate" => @success_rate,
			"tpCost" => @tp_cost,
			"tpGain" => @tp_gain
		}.to_json(*a)
	end

	attr_accessor :stype_id
	attr_accessor :mp_cost
	attr_accessor :tp_cost
	attr_accessor :message1
	attr_accessor :message2
	attr_accessor :required_wtype_id1
	attr_accessor :required_wtype_id2
end
