require_relative 'baseItemMV'

class RPG::EquipItemMV < RPG::BaseItemMV
	def initialize(json)
		super(json)
		@price = json["price"]
		@etype_id = json["etypeId"]
		@params = json["params"]
	end

	def etypeId
		@etype_id
	end

	def to_s
		s = super
		s << "Price: #{@price}\n"
		s << "Equipment Type: #{getEquipTypeMV(etype_id)}\n"
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