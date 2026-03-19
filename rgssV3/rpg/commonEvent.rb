class RPG::CommonEvent
	def initialize
		@id = 0
		@name = ""
		@trigger = 0
		@switch_id = 1
		@list = [RPG::EventCommand.new]
	end

	def updateFromJson(json)
		updateItemFromJson(@id, json["id"])
		updateItemFromJson(@name, json["name"])
		updateItemFromJson(@trigger, json["trigger"])
		updateItemFromJson(@switch_id, json["switchId"])
		listUpdateFromJson(@list, json["list"])
	end

	def getDiff(obj)
		diffs = []
		diffs << "ID changed" if @id != obj.id
		diffs << "Name changed" if @name != obj.name
		diffs << "Trigger changed" if @trigger != obj.trigger
		diffs << "Switch ID changed" if @switch_id != obj.switch_id
		diffs << "Event changed" unless @list == obj.list
		return diffs
	end

	def to_s
		s = ""
		s << "Common Event #{@id}#{@name.empty? ? "" : " - #{@name}"}\n"
		s << "Trigger: #{@trigger == 0 ? "None" : @trigger == 1 ? "Autorun" : "Parallel Process"}\n"
		if @trigger > 0
			sw = @switch_id
			sw = "#{sw.to_s.rjust(4, '0')}#{$SYSTEM.namedSwitch?(sw) ? ":#{$SYSTEM.getSwitchName(sw)}" : ""}" if $SYSTEM
			s << "Condition Switch: #{sw}\n"
		end
		s << "--------------- List of Event Commands ---------------\n"
		s << dumpEventArray(@list)
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"list" => @list,
			"name" => @name,
			"switchId" => @switch_id,
			"trigger" => @trigger
		}.to_json(*a)
	end

	attr_accessor :id
	attr_accessor :name
	attr_accessor :trigger
	attr_accessor :switch_id
	attr_accessor :list
end
