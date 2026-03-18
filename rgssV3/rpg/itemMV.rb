require_relative 'usableItemMV'

class RPG::ItemMV < RPG::UsableItemMV
	def initialize(json)
		super(json)
		@itype_id = json["itypeId"]
		@price = json["price"]
		@consumable = json["consumable"]
	end

	def itypeId
		@itype_id
	end

	def to_s
		s = "Item: #{padVariable(@id, 3)}\n"
		s << super
		s << "Item Type: #{getItemType(@itype_id)}\n"
		s << "Price: #{@price}\n"
		s << "Consumable: #{@consumable ? "Yes" : "No"}\n"
		return s
	end

	attr_accessor :itype_id
	attr_accessor :price
	attr_accessor :consumable
end
