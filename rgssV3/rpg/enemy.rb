require_relative 'baseItem'

class RPG::Enemy < RPG::BaseItem
	def initialize
		super
		@battler_name = ''
		@battler_hue = 0
		@params = [100,0,10,10,10,10,10,10]
		@exp = 0
		@gold = 0
		@drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
		@actions = [RPG::Enemy::Action.new]
		@features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
		@features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
		@features.push(RPG::BaseItem::Feature.new(31, 1, 0))
	end

	def initialize(json)
		super(json)
		@battler_name = json["battlerName"]
		@battler_hue = json["battlerHue"]
		@params = json["params"]
		@exp = json["exp"]
		@gold = json["gold"]
		@drop_items = json["dropItems"].map { |i| RPG::EnemyMV::DropItemMV.new(i) if i }
		@actions = json["actions"].map { |a| RPG::EnemyMV::ActionMV.new(a) if a }
	end

	def getDiff(obj)
		diffs = super
		diffs << "Battler Name changed" if @battler_name != obj.battler_name
		diffs << "Battler Hue changed" if @battler_hue != obj.battler_hue
		@params.each_with_index { | p, idx | diffs << "Parameter [#{idx}] changed" if p != obj.params[idx] }
		diffs << "EXP changed" if @exp != obj.exp
		diffs << "Gold changed" if @gold != obj.gold
		@drop_items.each_with_index { | i, idx | diffs += i.getDiff(obj.drop_items[idx], idx) }
		@actions.each_with_index { | a, idx | diffs += a.getDiff(obj.actions[idx], idx) }
		return diffs
	end

	def to_s
		s = "Enemy: #{padVariable(@id, 3)}\n"
		s << super
		s << "Graphic Name: #{@battler_name}\n"
		s << "Graphic Hue: #{@battler_hue}\n"
		s << "Maximum HP: #{@params[0]}\n"
		s << "Maximum MP: #{@params[1]}\n"
		s << "Attack: #{@params[2]}\n"
		s << "Defense: #{@params[3]}\n"
		s << "Magic: #{@params[4]}\n"
		s << "Magic Defense: #{@params[5]}\n"
		s << "Agility: #{@params[6]}\n"
		s << "Luck: #{@params[7]}\n"
		s << "Experience: #{@exp}\n"
		s << "Currency: #{@gold}\n"
		s << "Dropped Items:\n"
		@drop_items.each { |i| s << i.to_s }
		s << "Action Patterns:\n"
		@actions.each { |a| s << a.to_s }
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"actions" => @actions,
			"battlerHue" => @battler_hue,
			"battlerName" => @battler_name,
			"dropItems" => @drop_items,
			"exp" => @exp,
			"traits" => @features,
			"gold" => @gold,
			"name" => @name,
			"note" => @note,
			"params" => @params
		}.to_json(*a)
	end

	attr_accessor :battler_name
	attr_accessor :battler_hue
	attr_accessor :params
	attr_accessor :exp
	attr_accessor :gold
	attr_accessor :drop_items
	attr_accessor :actions
end

class RPG::Enemy::DropItem
	def initialize
		@kind = 0
		@data_id = 1
		@denominator = 1
	end

	def initialize(json)
		@kind = json["kind"]
		@data_id = json["dataId"]
		@denominator = json["denominator"]
	end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "DropItem [#{idx}]: New entry"
			return diffs
		end

		diffs << "DropItem [#{idx}]: Kind changed" if @kind != obj.kind
		diffs << "DropItem [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "DropItem [#{idx}]: Amount changed" if @denominator != obj.denominator
		return diffs
	end

	def to_s
		return "" if @kind == 0
		s = ""
		s << "#{parseItemType(@kind)}: #{parseDropItem(@kind, @data_id)}\n"
		s << "Appearance Rate: 1/#{@denominator}\n"
		return s
	end

	def to_json(*a)
		return {
			"kind" => @kind,
			"dataId" => @data_id,
			"denominator" => @denominator
		}.to_json(*a) if @denominator != 1 || (@denominator == 1 && @kind <= 1 && @data_id != 1) # Not sure if this makes any actual sense, but it worked for my sample game ...

		return {
			"dataId" => @data_id,
			"denominator" => @denominator,
			"kind" => @kind
		}.to_json(*a)
	end

	attr_accessor :kind
	attr_accessor :data_id
	attr_accessor :denominator
end

class RPG::Enemy::Action
	def initialize
		@skill_id = 1
		@condition_type = 0
		@condition_param1 = 0
		@condition_param2 = 0
		@rating = 5
	end

	def initialize(json)
		@skill_id = json["skillId"]
		@condition_type = json["conditionType"]
		@condition_param1 = json["conditionParam1"]
		@condition_param2 = json["conditionParam2"]
		@rating = json["rating"]
	end

	def skillId
		@skill_id
	end

	def conditionType
		@condition_type
	end

	def conditionParam1
		@condition_param1
	end

	def conditionParam2
		@condition_param2
	end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Action [#{idx}]: New entry"
			return diffs
		end

		diffs << "Action [#{idx}]: Skill ID changed" if @skill_id != obj.skill_id
		diffs << "Action [#{idx}]: Condition Type changed" if @condition_type != obj.condition_type
		diffs << "Action [#{idx}]: Condition Param 1 changed" if @condition_param1 != obj.condition_param1
		diffs << "Action [#{idx}]: Condition Param 2 changed" if @condition_param2 != obj.condition_param2
		diffs << "Action [#{idx}]: Rating changed" if @rating != obj.rating

		diffs.unshift("changed") unless diffs.empty?
		return diffs
	end

	def to_s
		s = ""
		s << "Skill: #{getSkill(@skill_id, false)}\n"
		s << "Condition: #{parseCondition(@condition_type, @condition_param1, @condition_param2)}\n"
		s << "Priority: #{@rating}\n"
		return s
	end

	def to_json(*a)
		return {
			"conditionParam1" => @condition_param1,
			"conditionParam2" => @condition_param2,
			"conditionType" => @condition_type,
			"rating" => @rating,
			"skillId" => @skill_id
		}.to_json(*a)
	end

	attr_accessor :skill_id
	attr_accessor :condition_type
	attr_accessor :condition_param1
	attr_accessor :condition_param2
	attr_accessor :rating
end
