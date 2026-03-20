require_relative 'utils'

class RPG::MoveRoute
	def initialize
		@repeat = true
		@skippable = false
		@wait = false
		@list = [RPG::MoveCommand.new]
	end

	def updateFromJson(json)
		@repeat = json["repeat"] if json["repeat"]
		@skippable = json["skippable"] if json["skippable"]
		@wait = json["wait"] if json["wait"]
		listUpdateFromJson(@list, json["list"])
	end

	def ==(obj)
		return false unless obj
		return false unless @repeat == obj.repeat
		return false unless @skippable == obj.skippable
		return false unless @wait == obj.wait
		return false unless @list == obj.list
		return true
	end

	def to_s
		s = parseMoveRouteOptions(self)
		s << "\nEvents:\n" unless @list.empty?
		@list.each { |e| s << e.to_s if e }
		return s
	end

	def to_json(*a)
		return {
			"list" => @list,
			"repeat" => @repeat,
			"skippable" => @skippable,
			"wait" => @wait
		}.to_json(*a)
	end

	attr_accessor :repeat
	attr_accessor :skippable
	attr_accessor :wait
	attr_accessor :list
end
