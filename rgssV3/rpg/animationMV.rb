require_relative 'animation'

class RPG::AnimationMV < RPG::Animation
	def initialize(json)
		super()
		@id = json["id"] if json["id"]
		@name = json["name"] if json["name"]
		@animation1_name = json["animation1Name"] if json["animation1Name"]
		@animation1_hue =  json["animation1Hue"] if json["animation1Hue"]
		@animation2_name = json["animation2Name"] if json["animation2Name"]
		@animation2_hue =  json["animation2Hue"] if json["animation2Hue"]
		@position = json["position"] if json["position"]
		@frame_max = 1

		@frames = json["frames"].map { |f| RPG::AnimationMV::FrameMV.new(f) if f } if json["frames"]
		@timings = json["timings"].map { |t| RPG::AnimationMV::TimingMV.new(t) if t } if json["timings"]

		@frame_max = @frames.size
	end

	def animation1Name
		@animation1_name
	end

	def animation1Hue
		@animation1_hue
	end

	def animation2Name
		@animation2_name
	end

	def animation2Hue
		@animation2_hue
	end
end

class RPG::AnimationMV::FrameMV < RPG::Animation::Frame
	def initialize(json)
		super()
		@cell_max = 0
		@cell_data = json
	end

	attr_accessor :cell_max
	attr_accessor :cell_data
end

class RPG::AnimationMV::TimingMV < RPG::Animation::Timing
	def initialize(json)
		super()
		@frame = json["frame"]
		@se = json["se"] ? RPG::SEMV.new(json["se"]) : nil 
		@flash_scope = json["flashScope"]
		@flash_color = Color.new(json["flashColor"][0],json["flashColor"][1],json["flashColor"][2],json["flashColor"][3])
		@flash_duration = json["flashDuration"]
		@conditions = json["conditions"]
	end

	def flashScope
		@flash_scope
	end

	def flashColor
		@flash_color
	end

	def flashDuration
		@flash_duration
	end
end
