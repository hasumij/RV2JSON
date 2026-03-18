require_relative 'troop'
require_relative 'eventCommandMV'

class RPG::TroopMV < RPG::Troop
	def initialize(json)
		super()
		@id = json["id"]
		@name = json["name"]
		@members = json["members"].map { |m| RPG::TroopMV::MemberMV.new(m) if m }
		if json["pages"]
			@pages = json["pages"].map { |p| RPG::TroopMV::PageMV.new(p) if p }
		else
			@pages = json["pages"]
		end
	end
end

class RPG::TroopMV::MemberMV < RPG::Troop::Member
	def initialize(json)
		super()
		@enemy_id = json["enemyId"]
		@x = json["x"]
		@y = json["y"]
		@hidden = json["hidden"]
	end

	def enemyId
		@enemy_id
	end
end

class RPG::TroopMV::PageMV < RPG::Troop::Page
	def initialize(json)
		super()
		@condition = RPG::TroopMV::PageMV::ConditionMV.new(json["conditions"])
		@span = json["span"]
		@list = json["list"].map { |e| RPG::EventCommandMV.new(e) if e }
	end
end

class RPG::TroopMV::PageMV::ConditionMV < RPG::Troop::Page::Condition
	def initialize(json)
		super()
		@turn_ending = json["turnEnding"]
		@turn_valid = json["turnValid"]
		@enemy_valid = json["enemyValid"]
		@actor_valid = json["actorValid"]
		@switch_valid = json["switchValid"]
		@turn_a = json["turnA"]
		@turn_b = json["turnB"]
		@enemy_index = json["enemyIndex"]
		@enemy_hp = json["enemyHp"]
		@actor_id = json["actorId"]
		@actor_hp = json["actorHp"]
		@switch_id = json["switchId"]
	end

	def turnEnding
		@turn_ending
	end

	def turnValid
		@turn_valid
	end

	def enemyValid
		@enemy_valid
	end

	def actorValid
		@actor_valid
	end

	def switchValid
		@switch_valid
	end

	def turnA
		@turn_a
	end

	def turnB
		@turn_b
	end

	def enemyIndex
		@enemy_index
	end

	def enemyHp
		@enemy_hp
	end

	def actorId
		@actor_id
	end

	def actorHp
		@actor_hp
	end

	def switchId
		@switch_id
	end
end
