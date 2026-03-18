require_relative 'baseItem'

class RPG::BaseItemMV < RPG::BaseItem
	def initialize(json)
		super()
		@id = json["id"]
		@name = json["name"]
		@icon_index = json["iconIndex"]
		@description = json["description"]
		@note = json["note"]
		@features = json["traits"].map { |t| RPG::BaseItemMV::FeatureMV.new(t) } if json["traits"]
	end

	def iconIndex
		@icon_index
	end

	def traits
		@features
	end
end

class RPG::BaseItemMV::FeatureMV < RPG::BaseItem::Feature
	def initialize(json)
		super()
		@code = json["code"]
		@data_id = json["dataId"]
		@value = json["value"]
	end

	def dataId
		@data_id
	end
end
