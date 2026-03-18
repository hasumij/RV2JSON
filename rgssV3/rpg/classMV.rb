require_relative 'baseItemMV'

class RPG::ClassMV < RPG::BaseItemMV
  def initialize(json)
    super(json)
    @exp_params = json["expParams"]
    @params = json["params"]
    @learnings = json["learnings"].map { |l| RPG::ClassMV::LearningMV.new(l) }
  end

	def expParams
		@exp_params
	end

	def to_s
		s = "Class: #{padVariable(@id, 3)}\n"
		s << "Name: #{@name}\n"
		s << "Experience Curve: #{@exp_params}\n"
		# s << "Parameter Growth Curves: #{@params}\n"
		s << "Skills:\n" unless @learnings.empty?
		@learnings.each { |l| s << l.to_s }
		s << "Traits:\n"
		@features.each {|f| s << f.to_s}
		s << "Note:\n#{@note}\n" if @note && !@note.empty?
		return s
	end

  attr_accessor :exp_params
  attr_accessor :params
  attr_accessor :learnings
end

class RPG::ClassMV::LearningMV < RPG::Class::Learning
	def initialize(json)
		super()
		@level = json["level"]
		@skill_id = json["skillId"]
		@note = json["note"]
	end

	def skillId
		@skill_id
	end
end
