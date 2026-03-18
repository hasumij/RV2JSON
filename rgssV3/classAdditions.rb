require_relative 'rpg'
require_relative 'rtp_filenames'

def buildTag(type, id, name)
	return "#{type} [#{id}][#{name}]"
end

def validateReferenceName(ref, typeStr, tag = "")
	return unless $ALL_FILES
	return unless ref
	return if ref.empty?
	puts "Unable to find corresponding file for (#{typeStr}): #{ref}" unless $ALL_FILES.include?(ref) || $RTP_FILENAMES.include?(ref)
	return if ref.ascii_only?
	puts "#{tag}: Non Ascii #{typeStr} Call: #{ref}" unless tag.empty?
	puts "Non Ascii #{typeStr} Call: #{ref}" if tag.empty?
end

def changeReferenceName!(ref)
	begin
		return if ref.empty?
		return unless $translationHash.has_key?(ref)
		return if $translationHash[ref].empty?
		newStr = $translationHash[ref]
		ref.clear
		ref << newStr
	rescue => e
		puts "Error: #{e.inspect}"
	end
end


def validateInlineScript(ref, tag)
	return if ref.empty?
	return if ref.ascii_only?
	puts "#{tag}: Potential resource related non ascii inline script call: #{ref}"
end

class RPG::AudioFile
	def validate(tag)
		validateReferenceName(@name, "Audio", tag)
	end

	def patch
		changeReferenceName!(@name)
	end
end

class RPG::MoveRoute
	def validate(tag)
		@list.each { |mC| mC.validate(tag) }
	end

	def patch
		@list.each { |mC| mC.patch }
	end

	def changeAudio
		@list.each { |mC| mC.changeAudio }
	end
end

class RPG::MoveCommand
	def validate(tag)
		case @code
		when 41 # Change Graphic
			validateReferenceName(@parameters[0], "Image", tag)
		when 44 # Play SE
			@parameters[0].validate(tag)
		end
	end

	def patch
		case @code
		when 41 # Change Graphic
			changeReferenceName!(@parameters[0])
		when 44 # Play SE
			@parameters[0].patch
		end
	end

	def changeAudio
		@parameters[0].patch if @code == 44 # Play SE
	end
end

class RPG::EventCommand
	def validate(tag)
		case @code
		when 231 # Display Picture
			validateReferenceName(@parameters[1], "Image", tag)
		when 101 # Face in MessageBox
			validateReferenceName(@parameters[0], "Message Image", tag)
		when 132, 133, 241, 245, 249, 250 # SE, BGM, ME, BGS
			@parameters[0].validate(tag)
		when 322 # Change Actor Graphic
			# Parameter 1 - Sprite Graphic
			validateReferenceName(@parameters[1], "Character Sprite", tag)
			# Parameter 3 - Face Graphic
			validateReferenceName(@parameters[3], "Character Face", tag)
		when 283 # Change Background
			validateReferenceName(@parameters[0], "Background", tag)
		when 205 # Move Route
			@parameters[1].validate(tag)
		when 355 # Script
			validateInlineScript(@parameters[0], tag)
		end
	end

	def patch
		case @code
		when 231 # Display Picture
			changeReferenceName!(@parameters[1])
		when 101 # Face in MessageBox
			changeReferenceName!(@parameters[0])
		when 132, 133, 241, 245, 249, 250 # SE, BGM, ME, BGS
			@parameters[0].patch
		when 322 # Change Actor Graphic
			# Parameter 1 - Sprite Graphic
			changeReferenceName!(@parameters[1])
			# Parameter 3 - Face Graphic
			changeReferenceName!(@parameters[3])
		when 283 # Change Background
			changeReferenceName!(@parameters[0])
		when 205 # Move Route
			@parameters[1].patch
		when 355 # Script
			changeScriptCall!(@parameters[0])
		end
	end

	def changeAudio
		case @code
		when 132, 133, 241, 245, 249, 250 # SE, BGM, ME, BGS
			@parameters[0].patch
		when 205 # Move Route
			@parameters[1].changeAudio
		end
	end
end


class RPG::Enemy
	def validate
		validateReferenceName(@battler_name, "Enemy Battler", buildTag("Enemy", @id, @name))
	end

	def patch
		changeReferenceName!(@battler_name)
	end
end

class RPG::CommonEvent
	def validate
		@list.each { |e| e.validate(buildTag("CommonEvent", @id, @name)) }
	end

	def patch
		@list.each { |e| e.patch }
	end

	def changeAudio
		@list.each { |e| e.changeAudio }
	end
end

class RPG::Animation
	def validate
		validateReferenceName(@animation1_name, "Animation1", buildTag("Animation", @id, @name))
		validateReferenceName(@animation2_name, "Animation2", buildTag("Animation", @id, @name))
		@timings.each { |t| t.se.validate(buildTag("Animation", @id, @name)) }
	end

	def patch
		changeReferenceName!(@animation1_name)
		changeReferenceName!(@animation2_name)
		@timings.each { |t| t.se.patch }
	end

	def changeAudio
		@timings.each { |t| t.se.patch }
	end
end

class RPG::Actor
	def validate
		validateReferenceName(@character_name, "Actor Sprite", buildTag("Actor", @id, @name))
		validateReferenceName(@face_name, "Actor Face", buildTag("Actor", @id, @name))
	end

	def patch
		changeReferenceName!(@character_name)
		changeReferenceName!(@face_name)
	end
end

class RPG::Event
	def validate
		@pages.each { |p| p.validate(buildTag("Event", @id, @name)) }
	end

	def patch
		@pages.each { |p| p.patch }
	end

	def changeAudio
		@pages.each { |p| p.changeAudio }
	end
end

class RPG::Event::Page
	def validate(tag)
		@list.each { |e| e.validate(tag) }
		@graphic.validate(tag)
		@move_route.validate(tag)
	end

	def patch
		@list.each { |e| e.patch }
		@graphic.patch
		@move_route.patch
	end

	def changeAudio
		@list.each { |e| e.changeAudio }
		@move_route.changeAudio
	end
end

class RPG::Event::Page::Graphic
	def validate(tag)
		validateReferenceName(@character_name, tag)
	end

	def patch
		changeReferenceName!(@character_name)
	end
end

class RPG::Map
	def validate
		@bgm.validate("Map BGM")
		@bgs.validate("Map BGS")
		validateReferenceName(@parallax_name, "Parallax Name")
		validateReferenceName(@battleback_floor_name, "Battleback Floor Name")
		validateReferenceName(@battleback_wall_name, "Battleback Wall Name")

		@events.each { |_,e| e.validate if e }
	end

	def patch
		@bgm.patch
		@bgs.patch
		changeReferenceName!(@parallax_name)
		changeReferenceName!(@battleback_floor_name)
		changeReferenceName!(@battleback_wall_name)

		@events.each { |_,e| e.patch if e }
	end

	def changeAudio
		@bgm.patch
		@bgs.patch

		@events.each { |_,e| e.changeAudio if e }
	end
end

class RPG::Troop
	def validate
		@pages.each { |p| p.validate(buildTag("Troop", @id, @name)) }
	end

	def patch
		@pages.each { |p| p.patch }
	end

	def changeAudio
		@pages.each { |p| p.changeAudio }
	end
end

class RPG::Troop::Page
	def validate(tag)
		@list.each { |e| e.validate(tag) }
	end

	def patch
		@list.each { |e| e.patch }
	end

	def changeAudio
		@list.each { |e| e.changeAudio }
	end
end

class RPG::Tileset
	def validate
		@tileset_names.each_with_index do |name, index|
			next if name.empty?
			validateReferenceName(name, "Tileset[#{index+1}]", buildTag("Tileset", @id, @name))
		end
	end

	def patch
		@tileset_names.each { |name| changeReferenceName!(name) unless name.empty? }
	end
end

class RPG::System
	def validate
		@boat.validate
		@ship.validate
		@airship.validate

		validateReferenceName(@title1_name, "Title Graphic 1")
		validateReferenceName(@title2_name, "Title Graphic 2")

		@title_bgm.validate("Title BGM")
		@battle_bgm.validate("Battle BGM")
		@battle_end_me.validate("End ME")
		@gameover_me.validate("Gameover ME")

		@sounds.each { |s| s.validate("System Audio") }

		validateReferenceName(@battleback1_name, "System BattleBack 1")
		validateReferenceName(@battleback2_name, "System BattleBack 2")
		validateReferenceName(@battler_name, "System Battler")
	end

	def patch
		@boat.patch
		@ship.patch
		@airship.patch

		changeReferenceName!(@title1_name)
		changeReferenceName!(@title2_name)

		@title_bgm.patch
		@battle_bgm.patch
		@battle_end_me.patch
		@gameover_me.patch

		@sounds.each { |s| s.patch }

		changeReferenceName!(@battleback1_name)
		changeReferenceName!(@battleback2_name)
		changeReferenceName!(@battler_name)
	end

	def changeAudio
		@boat.changeAudio
		@ship.changeAudio
		@airship.changeAudio

		@title_bgm.patch
		@battle_bgm.patch
		@battle_end_me.patch
		@gameover_me.patch

		@sounds.each { |s| s.patch }
	end
end

class RPG::System::Vehicle
	def validate
		validateReferenceName(@character_name, "#{character_name} Sprite")
		@bgm.validate("#{character_name} BGM")
	end

	def patch
		changeReferenceName!(@character_name)
		@bgm.patch
	end

	def changeAudio
		@bgm.patch
	end
end
