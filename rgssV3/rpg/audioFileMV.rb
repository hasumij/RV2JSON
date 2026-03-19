class RPG::AudioFileMV < RPG::AudioFile
	def initialize(json)
		super()
		@name = json["name"]
		@pitch = json["pitch"]
		@volume = json["volume"]
		@pan = json["pan"]
	end

	def to_s
		s = super()
		s << "Pan: #{@pan}\n"
		return s
	end

	attr_accessor :pan
end

class RPG::SEMV < RPG::AudioFileMV
end

class RPG::BGMMV < RPG::AudioFileMV
end

class RPG::BGSMV < RPG::AudioFileMV
end

class RPG::MEMV < RPG::AudioFileMV
end
