require_relative 'equipItem'

class RPG::Armor < RPG::EquipItem
	def initialize
		super
		@atype_id = 0
		@etype_id = 1
		@features.push(RPG::BaseItem::Feature.new(22, 1, 0))
	end

	def initialize(json)
		super(json)
		@atype_id = json["atypeId"]
		@etype_id = json["etypeId"]
	end

	def updateFromJson(json)
		super(json)
		updateItemFromJson(@atype_id, json["atypeId"])
		updateItemFromJson(@etype_id, json["etypeId"])
	end

	def getDiff(obj)
		diffs = super
		diffs << "Armor Type ID changed" if @atype_id != obj.atype_id
		return diffs
	end

	def performance
		params[3] + params[5] + params.inject(0) {|r, v| r += v }
	end

	def to_s
		s = "Armor: #{padVariable(@id, 3)}\n"
		s << super
		s << "Armor Type: #{getArmorType(@atype_id)}\n"
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"atypeId" => @atype_id,
			"description" => @description,
			"etypeId" => @etype_id,
			"traits" => @features,
			"iconIndex" => @icon_index,
			"name" => @name,
			"note" => @note,
			"params" => @params,
			"price" => @price
		}.to_json(*a)
	end

	attr_accessor :atype_id
end