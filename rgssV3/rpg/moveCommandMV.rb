require_relative 'moveCommand'

class RPG::MoveCommandMV < RPG::MoveCommand
	def initialize(json)
		super()
		@code = json["code"]
		@indent = json["indent"]
		@indentValid = json.key?("indent")
		@parameters = case @code
			when 44; [RPG::SEMV.new(json["parameters"][0])]
			else; json["parameters"] 
		end
	end

	attr_accessor :indent
end

