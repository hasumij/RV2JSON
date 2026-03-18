require_relative 'eventCommand'
require_relative 'moveRouteMV'
require_relative 'moveCommandMV'

class RPG::EventCommandMV < RPG::EventCommand
	def initialize(json)
		super()
		@code = json["code"]
		@indent = json["indent"]

		@parameters = case @code
			when 205; [json["parameters"][0], RPG::MoveRouteMV.new(json["parameters"][1])]
			when 132, 241; [RPG::BGMMV.new(json["parameters"][0])]
			when 245; [RPG::BGSMV.new(json["parameters"][0])]
			when 133, 249; [RPG::MEMV.new(json["parameters"][0])]
			when 250; [RPG::SEMV.new(json["parameters"][0])]
			when 505; [RPG::MoveCommandMV.new(json["parameters"][0])]
			else; json["parameters"]
		end unless json["parameters"].empty?
	end
end
