require_relative 'moveRoute'
require_relative 'moveCommandMV'

class RPG::MoveRouteMV < RPG::MoveRoute
	def initialize(json)
		super()
		@repeat = json["repeat"]
		@skippable = json["skippable"]
		@wait = json["wait"]
		@list = json["list"].map { |e| RPG::MoveCommandMV.new(e) }
	end
end
