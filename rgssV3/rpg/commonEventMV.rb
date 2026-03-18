require_relative 'commonEvent'
require_relative 'eventCommand'

class RPG::CommonEventMV < RPG::CommonEvent
	def initialize(json)
		super()
		@id = json["id"]
		@name = json["name"]
		@trigger = json["trigger"]
		@switch_id = json["switchId"]
		@list = json["list"].map { |e| RPG::EventCommandMV.new(e) }
	end

	def switchId
		@switch_id
	end
end
