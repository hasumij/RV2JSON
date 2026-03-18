class RPG::Tileset
	def initialize
		@id = 0
		@mode = 1
		@name = ''
		@tileset_names = Array.new(9).collect{''}
		@flags = Table.new(8192)
		@flags[0] = 0x0010
		(2048..2815).each {|i| @flags[i] = 0x000F}
		(4352..8191).each {|i| @flags[i] = 0x000F}
		@note = ''
	end

	def to_s
		s = "Tileset: #{padVariable(@id, 3)}\n"
		s << "Name: #{@name}\n"
		s << "Mode: #{parseTilesetMode(@mode)}\n"
		s << "Graphics:\n"
		s << "A1 (Animated): #{@tileset_names[0]}\n" unless @tileset_names[0].empty?
		s << "A2 (Terrain): #{@tileset_names[1]}\n" unless @tileset_names[1].empty?
		s << "A3 (Buildings): #{@tileset_names[2]}\n" unless @tileset_names[2].empty?
		s << "A4 (Walls): #{@tileset_names[3]}\n" unless @tileset_names[3].empty?
		s << "A5 (General): #{@tileset_names[4]}\n" unless @tileset_names[4].empty?
		s << "B: #{@tileset_names[5]}\n" unless @tileset_names[5].empty?
		s << "C: #{@tileset_names[6]}\n" unless @tileset_names[6].empty?
		s << "D: #{@tileset_names[7]}\n" unless @tileset_names[7].empty?
		s << "E: #{@tileset_names[8]}\n" unless @tileset_names[8].empty?
		s << "Note: #{@note}\n" unless @note.empty?
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"flags" => @flags,
			"mode" => @mode,
			"name" => @name,
			"note" => @note,
			"tilesetNames" => @tileset_names
		}.to_json(*a)
	end

	attr_accessor :id
	attr_accessor :mode
	attr_accessor :name
	attr_accessor :tileset_names
	attr_accessor :flags
	attr_accessor :note
end
