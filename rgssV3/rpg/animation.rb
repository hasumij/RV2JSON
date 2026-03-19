class RPG::Animation
	def initialize
		@id = 0
		@name = ''
		@animation1_name = ''
		@animation1_hue = 0
		@animation2_name = ''
		@animation2_hue = 0
		@position = 1
		@frame_max = 1
		@frames = [RPG::Animation::Frame.new]
		@timings = []
	end

	def updateFromJson(json)
		# For now don't do anything here
	end

	def to_s
		s = "Animation: #{padVariable(@id, 3)}\n"
		s << "Name: #{@name}\n"
		s << "Graphic:\n"
		s << "Name: #{@animation1_name} | Hue: #{@animation1_hue}\n" unless @animation1_name.empty?
		s << "Name: #{@animation2_name} | Hue: #{@animation2_hue}\n" unless @animation2_name.empty?
		s << "Position: #{@position}\n"
		s << "Frame Max: #{frame_max}\n"
		s << "SE and Flash Timings:\n"
		@timings.each { |t| s << t.to_s }
		return s
	end

	def to_json(*a)
		return {
			"id" => @id,
			"animation1Hue" => @animation1_hue,
			"animation1Name" => @animation1_name,
			"animation2Hue" => @animation2_hue,
			"animation2Name" => @animation2_name,
			"frames" => @frames,
			"name" => @name,
			"position" => @position,
			"timings" => @timings
		}.to_json(*a)
	end

	def to_screen?
		@position == 3
	end

	attr_accessor :id
	attr_accessor :name
	attr_accessor :animation1_name
	attr_accessor :animation1_hue
	attr_accessor :animation2_name
	attr_accessor :animation2_hue
	attr_accessor :position
	attr_accessor :frame_max
	attr_accessor :frames
	attr_accessor :timings
end

class RPG::Animation::Frame
	def initialize
		@cell_max = 0
		@cell_data = Table.new(0, 0)
	end

	def to_json(*a)
		return @cell_data.to_json(*a)
	end

	attr_accessor :cell_max
	attr_accessor :cell_data
end

class RPG::Animation::Timing
	def initialize
		@frame = 0
		@se = RPG::SE.new('', 80)
		@flash_scope = 0
		@flash_color = Color.new(255,255,255,255)
		@flash_duration = 5
	end

	def to_s
		s = ""
		s << "Frame No. #{padVariable(@frame+1, 3)}\n"
		s << "SE:\n#{@se.to_s}"
		s << "Flash: #{parseFlashScope(@flash_scope)} #{@flash_color}, @#{@flash_duration}\n" unless @flash_scope == 0
		s << "Flash: None\n" if @flash_scope == 0
		return s
	end

	def to_json(*a)
		j = @conditions ? {"conditions" => @conditions} : {}
		j.merge!({
			"flashColor" => [@flash_color.red, @flash_color.green, @flash_color.blue, @flash_color.alpha],
			"flashDuration" => @flash_duration,
			"flashScope" => @flash_scope,
			"frame" => @frame,
			"se" => @se
		})
		return j.to_json(*a)
	end

	attr_accessor :frame
	attr_accessor :se
	attr_accessor :flash_scope
	attr_accessor :flash_color
	attr_accessor :flash_duration
end
