require_relative 'baseItem'

class RPG::EquipItem < RPG::BaseItem
	def initialize
		super
		@price = 0
		@etype_id = 0
		@params = [0] * 8
	end

	def initialize(json)
		super(json)
		@price = json["price"]
		@etype_id = json["etypeId"]
		@params = json["params"]
	end

	def updateFromJson(json)
		super(json)
		updateItemFromJson(@price, json["price"])
		updateItemFromJson(@etype_id, json["etypeId"])
		
		# @params = json["params"] if json["params"]
	end

	def etypeId
		@etype_id
	end

	def getDiff(obj)
		diffs = super
		diffs << "Damage Price changed" if @price != obj.price
		diffs << "Damage Equip Type ID changed" if @etype_id != obj.etype_id
		@params.each_with_index { | p, idx | diffs << "Parameter [#{idx}] changed" if p != obj.params[idx] }
		return diffs
	end
	
	def to_s
		s = super
		s << "Price: #{@price}\n"
		s << "Equipment Type: #{parseEquip(etype_id, -1)}\n" unless @etype_id == 0
		s << "Parameter Changes:\n"
		s << "Attack: #{@params[2]}\n"
		s << "Defense: #{@params[3]}\n"
		s << "Magic: #{@params[4]}\n"
		s << "Magic Defense: #{@params[5]}\n"
		s << "Agility: #{@params[6]}\n"
		s << "Luck: #{@params[7]}\n"
		s << "Maximum HP: #{@params[0]}\n"
		s << "Maximum MP: #{@params[1]}\n"
		return s
	end

	attr_accessor :price
	attr_accessor :etype_id
	attr_accessor :params
end