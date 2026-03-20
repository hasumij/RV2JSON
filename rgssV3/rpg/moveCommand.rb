require_relative 'utils'

class RPG::MoveCommand
	def initialize(code = 0, parameters = [])
		@code = code
		@parameters = parameters
	end

	def updateFromJson(json)
		@code = json["code"] if json["code"]
		updateParametersFromJson(@parameters, json["parameters"])
	end

	def ==(obj)
		return false unless obj
		return false unless @code == obj.code
		return false unless @parameters == obj.parameters
		return true
	end

	def to_s
		return case @code
			when  0; ""
			when  1; "Move Down"
			when  2; "Move Left"
			when  3; "Move Right"
			when  4; "Move Up"
			when  5; "Move to the Lower Left"
			when  6; "Move to the Lower Right"
			when  7; "Move to the Upper Left"
			when  8; "Move to the Upper Right"
			when  9; "Move in a Random Direction"
			when 10; "Move Towards Player"
			when 11; "Move Away from Player"
			when 12; "One Step Forward"
			when 13; "One Step Backward"
			when 14; "Jump: #{@parameters[0] >= 0 ? "+" : ""}#{@parameters[0]},#{@parameters[1] >= 0 ? "+" : ""}#{@parameters[1]}"
			when 15; "Wait: #{@parameters[0]} Frames"
			when 16; "Turn Down"
			when 17; "Turn Left"
			when 18; "Turn Right"
			when 19; "Turn Up"
			when 20; "Turn Right 90°"
			when 21; "Turn Left 90°"
			when 22; "Turn 180°"
			when 23; "Turn Right or Left 90°"
			when 24; "Turn in a Random Direction"
			when 25; "Turn Towards Player"
			when 26; "Turn Away from Player"
			when 27; "Switch ON: #{padVariable(@parameters[0])}"
			when 28; "Switch OFF: #{padVariable(@parameters[0])}"
			when 29; "Change Speed: #{@parameters[0]}"
			when 30; "Change Frequency: #{@parameters[0]}"
			when 31; "Walking Animation ON"
			when 32; "Walking Animation OFF"
			when 33; "Step Animation ON"
			when 34; "Step Animation OFF"
			when 35; "Direction Fix ON"
			when 36; "Direction Fix OFF"
			when 37; "Passage ON"
			when 38; "Passage OFF"
			when 39; "Transparency ON"
			when 40; "Transparency OFF"
			when 41; "Change Graphic: #{parseImage(@parameters[0], @parameters[1])}"
			when 42; "Change Opacity: #{@parameters[0]}"
			when 43; "Change Blend Type: #{parseBlendType(@parameters[0])}"
			when 44; "Play SE: #{parseAudio(@parameters[0])}"
			when 45; "Script: #{@parameters[0]}"
			else
				puts "UNKNOWN MoveCommand Code: #{@code}"
				""
		end
	end

	def to_json(*a)
		json = {"code" => @code}
		json.merge!({"parameters" => @parameters}) if @parameters
		return json.to_json(*a)
	end

	attr_accessor :code
	attr_accessor :parameters
end

