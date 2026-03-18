require_relative 'tileset'

class RPG::TilesetMV < RPG::Tileset
	def initialize(json)
		super()
		@id = json["id"]
		@mode = json["mode"]
		@name = json["name"]
		@tileset_names = json["tilesetNames"]
		@flags = json["flags"]
		@note = json["note"]
	end

	def tilesetNames
		@tileset_names
	end
end
