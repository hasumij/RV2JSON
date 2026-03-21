class RPG::MapInfo
	def initialize
		@name      = ""
		@parent_id = 0
		@order	   = 0
		@expanded  = false
		@scroll_x  = 0
		@scroll_y  = 0
	end

	def initialize(json)
		@name = json["name"]
		@id = json["id"]
		@parent_id = json["parentId"]
		@order = json["order"]
		@expanded	= json["expanded"]
		@scroll_x	= json["scrollX"]
		@scroll_y	= json["scrollY"]
	end

	def updateFromJson(json)
		@name = json["name"].encode(@name.encoding) if json["name"]
		@id = json["id"] if json["id"]
		@parent_id = json["parentId"] if json["parentId"]
		@order = json["order"] if json["order"]
		@expanded = json["expanded"] if json["expanded"]
		@scroll_x = json["scrollX"] if json["scrollX"]
		@scroll_y = json["scrollY"] if json["scrollY"]
	end

	def to_json(*a)
		return {
			"id" => @id,
			"expanded" => @expanded,
			"name" => @name,
			"order" => @order,
			"parentId" => @parent_id,
			"scrollX" => @scroll_x,
			"scrollY" => @scroll_y
		}.to_json(*a)
	end

	attr_accessor :name
	attr_accessor :parent_id
	attr_accessor :order
	attr_accessor :expanded
	attr_accessor :scroll_x
	attr_accessor :scroll_y
end
