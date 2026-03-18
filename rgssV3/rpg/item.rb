require_relative 'usableItem'

class RPG::Item < RPG::UsableItem
	def initialize
		super
		@scope = 7
		@itype_id = 1
		@price = 0
		@consumable = true
	end
	def key_item?
		@itype_id == 2
	end

	def getDiff(obj)
		diffs = super
		diffs << "Item Type ID changed" if @itype_id != obj.itype_id
		diffs << "Price changed" if @price != obj.price
		diffs << "Consumable changed" if @consumable != obj.consumable
		return diffs
	end

	def to_s
		s = "Item: #{padVariable(@id, 3)}\n"
		s << super
		s << "Item Type: #{getItemType(@itype_id)}\n"
		s << "Price: #{@price}\n"
		s << "Consumable: #{@consumable ? "Yes" : "No"}\n"
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"animationId" => @animation_id,
			"consumable" => @consumable,
			"damage" => @damage,
			"description" => @description,
			"effects" => @effects,
			"hitType" => @hit_type,
			"iconIndex" => @icon_index,
			"itypeId" => @itype_id,
			"name" => @name,
			"note" => @note,
			"occasion" => @occasion,
			"price" => @price,
			"repeats" => @repeats,
			"scope" => @scope,
			"speed" => @speed,
			"successRate" => @success_rate,
			"tpGain" => @tp_gain
		}.to_json(*a)
	end

	attr_accessor :itype_id
	attr_accessor :price
	attr_accessor :consumable
end
