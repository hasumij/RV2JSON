require_relative 'equipItem'

class RPG::Weapon < RPG::EquipItem
	def initialize
		super
		@wtype_id = 0
		@animation_id = 0
		@features.push(RPG::BaseItem::Feature.new(31, 1, 0))
		@features.push(RPG::BaseItem::Feature.new(22, 0, 0))
	end

	def initialize(json)
		super(json)
		@wtype_id = json["wtypeId"]
		@animation_id = json["animationId"]
	end

	def updateFromJson(json)
		super(json)
		@wtype_id = json["wtypeId"]
		@animation_id = json["animationId"]
	end

	def getDiff(obj)
		diffs = super
		diffs << "Weapon Type ID changed" if @wtype_id != obj.wtype_id
		diffs << "Animation ID changed" if @animation_id != obj.animation_id
		return diffs
	end

	def performance
		params[2] + params[4] + params.inject(0) {|r, v| r += v }
	end
	
	def to_s
		s = "Weapon: #{padVariable(@id, 3)}\n"
		s << super
		s << "Weapon Type: #{getWeaponType(@wtype_id)}\n"
		s << "Animation: #{getAnimation(@animation_id, false)}\n"
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"animationId" => @animation_id,
			"description" => @description,
			"etypeId" => @etype_id,
			"traits" => @features,
			"iconIndex" => @icon_index,
			"name" => @name,
			"note" => @note,
			"params" => @params,
			"price" => @price,
			"wtypeId" => @wtype_id
		}.to_json(*a)
	end

	attr_accessor :wtype_id
	attr_accessor :animation_id
end