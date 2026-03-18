require_relative 'baseItemMV'

class RPG::EnemyMV < RPG::BaseItemMV
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

	def battlerName
		@battler_name
	end

	def battlerHue
		@battler_hue
	end

	def dropItems
		@drop_items
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

	attr_accessor :battler_name
	attr_accessor :battler_hue
	attr_accessor :params
	attr_accessor :exp
	attr_accessor :gold
	attr_accessor :drop_items
	attr_accessor :actions
end

class RPG::EnemyMV::DropItemMV < RPG::Enemy::DropItem
	def initialize(json)
		super()
		@kind = json["kind"]
		@data_id = json["dataId"]
		@denominator = json["denominator"]
	end
end

class RPG::EnemyMV::ActionMV < RPG::Enemy::Action
	def initialize(json)
		super()
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
end
