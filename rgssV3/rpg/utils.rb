def dumpEventArray(a)
	s = ""
	a.each do |e| 
		begin
			s << e.to_s << "\n"
			rescue => ex
				puts "[#{@name}] Failed to parse event with code: #{e.code} - (#{ex.inspect})"
				s << "ERROR: #{ex.inspect}"
			end
		end
	return s
end

def arrayHasName?(a, id)
	return false if id == 0
	return a.size > id && !(a[id].name.empty?)
end

def getSwitch(s)
	arr = $OBJECTS["System"]
	return "[#{padVariable(s)}]" unless arr
	return "[#{padVariable(s)}#{arr.namedSwitch?(s) ? ":#{arr.getSwitchName(s)}" : ""}]"
end

def getVariable(v, n = false)
	arr = $OBJECTS["System"]
	return "[#{padVariable(v)}]" unless arr && !n
	return "[#{padVariable(v)}#{arr.namedVariable?(v) ? ":#{arr.getVariableName(v)}" : ""}]"
end

def getComEv(c)
	arr = $OBJECTS["CommonEvents"]
	return "[#{c}]" unless arr
	return "[#{c}#{arrayHasName?(arr, c) ? ":#{arr[c].name}" : ""}]"
end

def getBaseElement(name, e, b = true)
	return "(None)" unless e
	arr = $OBJECTS[name]
	return "[#{e}]" unless arr && arrayHasName?(arr, e)
	return "[#{arr[e].name}]" if b
	return "#{arr[e].name}"
end

def getItem(i, b = true)
	return getBaseElement("Items", i, b)
end

def getWeapon(w, b = true)
	return "(None)" if w == 0
	return getBaseElement("Weapons", w, b)
end

def getArmor(a, b = true)
	return "(None)" if a == 0
	return getBaseElement("Armors", a, b)
end

def getActor(a, b = true)
	return getBaseElement("Actors", a, b)
end

def getState(s, b = true)
	return getBaseElement("States", s, b)
end

def getClass(c, b = true)
	return getBaseElement("Classes", c, b)
end

def getSkill(s, b = true)
	return getBaseElement("Skills", s, b)
end

def getAnimation(a, b = true)
	return "Normal Attack" if a == -1
	return "None" if a == 0
	return getBaseElement("Animations", a, b)
end

def getTroop(t)
	return getBaseElement("Troops", t, false)
end

def getEnemy(e, b = false)
	return getBaseElement("Enemies", e, b)
end

def getTileset(t)
	return getBaseElement("Tilesets", t, false)
end

def getElement(e)
	return "Normal Attack" if e == -1
	return "None" if e == 0
	return $OBJECTS["System"].elements[e] if $OBJECTS["System"] && e < $OBJECTS["System"].elements.size
	return ""
end

def getWeaponType(t)
	return "None" if t == 0
	return $OBJECTS["System"].weapon_types[t] if $OBJECTS["System"] && t < $OBJECTS["System"].weapon_types.size
	return ""
end

def getSkillType(t)
	return "None" if t == 0
	return $OBJECTS["System"].skill_types[t] if $OBJECTS["System"] && t < $OBJECTS["System"].skill_types.size
	return ""
end

def getArmorType(t)
	return "None" if t == 0
	return $OBJECTS["System"].armor_types[t] if $OBJECTS["System"] && t < $OBJECTS["System"].armor_types.size
	return ""
end

def getEquipTypeMV(t)
		return $OBJECTS["System"].equipTypes[t] if $OBJECTS["System"] && $OBJECTS["System"].class == RPG::SystemMV && t < $OBJECTS["System"].equipTypes.size
		return ""
end

def parseAudio(a)
	return "#{a.name.empty? ? "(None)" : "'#{a.name}', #{a.volume}, #{a.pitch}"}"
end

def parseOperation(p)
	return p == 0 ? "+" : "-";
end

def parseSwitch(p)
	return p == 0 ? "ON" : "OFF"
end

def parseAccess(a)
	return a == 0 ? "Disable" : "Enable"
end

def parseIncEquip(p)
	return p ? ", Include Equipped" : "" 
end

def parseWait(w)
	return w ? ", Wait" : ""
end

def padVariable(v, p = 4)
	return v.to_s.rjust(p, '0')
end

def parseValue(p, v)
	return p == 0 ? v : "Variable #{getVariable(v)}"
end

def parseVariable2(v1, v2)
	return "Variable #{getVariable(v1, true)}#{getVariable(v2, true)}"
end

def parseVariable3(v1, v2, v3)
	return "Variable #{getVariable(v1, true)}#{getVariable(v2, true)}#{getVariable(v3, true)}"
end

def parsePosition(x, y)
	return "(#{padVariable(x, 3)}, #{padVariable(y, 3)})"
end

def getMapName(m)
	return "[#{padVariable(m, 3)}]" unless $OBJECTS["MapInfos"] && $OBJECTS["MapInfos"].key?(m) && $OBJECTS["MapInfos"][m] != nil
	return "[#{padVariable(m, 3)}:#{$OBJECTS["MapInfos"][m].name}]"
end

def getItemType(t)
	return "Normal" if t == 1
	return $OBJECTS["System"].terms.commands[14] if t == 2 && $OBJECTS["System"] # Command[14] == Key Item
	return ""
end

def parseMapPosition(m, x, y)
	return "(None)" if m == 0
	return "#{getMapName(m)}#{parsePosition(x, y)}"
end

def parseTime(t)
	min = @parameters[1] / 60
	sec = @parameters[1] - (min * 60)
	return min, sec
end

def parseGL(p)
	return p == 0 ? "Greater" : "Less"
end

def parseCompare(p)
	return case p
		when 0; "=="
		when 1; ">="
		when 2; "<="
		when 3; ">" 
		when 4; "<" 
		when 5; "!="
	end
end

def parseOperator(o)
	return case o
		when 0; ""
		when 1; "+"
		when 2; "-"
		when 3; "*"
		when 4; "/"
		when 5; "%"
	end
end

def parseButton(b)
	return case b
		when 2; "Down"
		when 4; "Left"
		when 6; "Right"
		when 8; "Up"
		when 11; "A"
		when 12; "B"
		when 13; "C"
		when 14; "X"
		when 15; "Y"
		when 16; "Z"
		when 17; "L"
		when 18; "R"
	end
end

def parseTarget(p, v)
	target = v == 0 ? "Entire Party" : getActor(v)
	target = "Variable #{getVariable(v)}" if p == 1
	return target
end

def parseImage(g, i = -1)
	return "(None)" if g.empty?
	return "'#{g}', #{i}" unless i == -1
	return "'#{g}'"
end

def parseState(s)
	return case s
		when 0; "Maximum HP"
		when 1; "Maximum MP"
		when 2; "Attack"
		when 3; "Defense"
		when 4; "Magic"
		when 5; "Magic Defense"
		when 6; "Agility"
		when 7; "Luck"
	end
end

def parseAddState(s)
	return case s
		when 0; "Hit Rate"
		when 1; "Evasion Rate"
		when 2; "Critical Rate"
		when 3; "Critical Evasion Rate"
		when 4; "Magic Evasion Rate"
		when 5; "Magic Reflection"
		when 6; "Counterattack Rate"
		when 7; "HP Regeneration Rate"
		when 8; "MP Regeneration Rate"
		when 9; "TP Regeneration Rate"
	end
end

def parseSpecialState(s)
	return case s
		when 0; "Accuracy Rate"
		when 1; "Defense Effect Rate"
		when 2; "Recovery Effect Rate"
		when 3; "Knowledge in Medicine"
		when 4; "MP Cost Rate"
		when 5; "TP Charge Rate"
		when 6; "Physical Damage Rate"
		when 7; "Magic Damage Rate"
		when 8; "Floor Damage Rate"
		when 9; "Experience Acquisition Rate"
	end
end

def parseEnemyState(s)
	return case s
		when 0; "HP"
		when 1; "MP"
		when 2; "Maximum HP"
		when 3; "Maximum MP"
		when 4; "Attack"
		when 5; "Defense"
		when 6; "Magic"
		when 7; "Magic Defense"
		when 8; "Agility"
		when 9; "Luck"
	end
end

def parseActorState(s)
	return case s
		when  0; "Level"
		when  1; "Experience"
		when  2; "HP"
		when  3; "MP"
		when  4; "Maximum HP"
		when  5; "Maximum MP"
		when  6; "Attack"
		when  7; "Defense"
		when  8; "Magic"
		when  9; "Magic Defense"
		when 10; "Agility"
		when 11; "Luck"
	end
end

def parsePosStr(p)
	return case p
		when 0; "Map X"
		when 1; "Map Y"
		when 2; "Direction"
		when 3; "Screen X"
		when 4; "Screen Y"
	end
end

def parsePartySlot(s)
	return case s
		when 0; "1st Member Slot"
		when 1; "2nd Member Slot"
		when 2; "3rd Member Slot"
		when 3; "4th Member Slot"
		when 4; "5th Member Slot"
		when 5; "6th Member Slot"
		when 6; "7th Member Slot"
		when 7; "8th Member Slot"
	end
end

def parseVarOptOther(o)
	return case o
		when 0; "Map ID"
		when 1; "Party Size"
		when 2; "Currency"
		when 3; "Steps Taken"
		when 4; "Play Time"
		when 5; "Timer is"
		when 6; "Save Count"
		when 7; "Combat Count"
	end
end

def parseEquipment(e)
	return case e
		when 0; "Weapon"
		when 1; "Shield"
		when 2; "Head"
		when 3; "Body"
		when 4; "Accessory"
	end
end

def parseEquip(e, i)
	s = $ENGINE == :vxace ? parseEquipment(e) : getEquipTypeMV(e)
	
	s += " = #{getWeapon(i)}" if e == 0
	s += " = #{getArmor(i)}" if e != 0 && i != -1
	return s
end

def parseEvent(e)
	ev = "[EV#{e.to_s.rjust(3, '0')}]"
	ev = "Player" if e == -1
	ev = "This Event" if e == 0
	return ev
end

def parseVehicle(v)
	return case v
		when 0; "Boat"
		when 1; "Ship"
		when 2; "Airship"
	end
end

def parseFade(f)
	return case f
		when 0; ""
		when 1; "White"
		when 2; "None"
	end
end

def parseBalloon(b)
	return case b
		when 0; ""
		when 1; "Exclamation"
		when 2; "Question"
		when 3; "Music Note"
		when 4; "Heart"
		when 5; "Anger"
		when 6; "Sweat"
		when 7; "Disheveled"
		when 8; "Silence"
		when 9; "Light Bulb"
		when 10; "Zzz"
	end
end

def parseBlendType(t)
	return case t
		when 0; "Normal"
		when 1; "Add"
		when 2; "Subtract"
	end
end

def parseImgPos(o, v, x, y)
	var = "(#{x},#{y})" if v == 0
	var = "(#{parseVariable2(x, y)})" if v == 1
	return "#{o == 0 ? "Upper Left" : "Center"} #{var}"
end

def parseTypeInfo(t)
	return case t
		when 0; "Terrain Tag"
		when 1; "Event ID"
		when 2; "Tile ID (Layer 1)"
		when 3; "Tile ID (Layer 2)"
		when 4; "Tile ID (Layer 3)"
		when 5; "Region ID"
	end
end

def parseActor(t, a)
	return "Entire Troop" if (t == 0 && a == -1)
	return "[#{a+1}. ]" if t == 0 # Enemy
	return "#{getActor(a)}"     if t == 1 # Player
end

def parseActionTarget(t)
	return case t
		when -2; "Last Target"
		when -1; "Random"
		when  0; "Index 1"
		when  1; "Index 2"
		when  2; "Index 3"
		when  3; "Index 4"
		when  4; "Index 5"
		when  5; "Index 6"
		when  6; "Index 7"
		when  7; "Index 8"
	end
end

def parseMoveRouteOptions(m)
	o = ""
	o << "Repeat" if m.repeat
	o << ", " if m.skippable && !o.empty?
	o << "Skip" if m.skippable
	o << ", " if m.wait && !o.empty?
	o << "Wait" if m.wait
	o = " (#{o})" unless o.empty?
	return o
end

def parseShopItem(t, i)
	return case t
		when 0; getItem(i)
		when 1; getWeapon(i)
		when 2; getArmor(i)
	end
end

def parseDropItem(t, i)
	return case t
		when 0; ""
		when 1; getItem(i, false)
		when 2; getWeapon(i, false)
		when 3; getArmor(i, false)
	end
end

def parseHitType(t)
	return case t
		when 0; "Guaranteed Hit"
		when 1; "Physical Attack"
		when 2; "Magic Attack"
	end
end

def parseDamageType(d)
	return case d
		when 0; "None"
		when 1; "HP Damage"
		when 2; "MP Damage"
		when 3; "HP Recovery"
		when 4; "MP Recovery"
		when 5; "HP Absorption"
		when 6; "MP Absorption"
	end
end

def parseAoE(a)
	return case a
		when  0; "None"
		when  1; "One Enemy"
		when  2; "All Enemies"
		when  3; "1 Random Enemy"
		when  4; "2 Random Enemies"
		when  5; "3 Random Enemies"
		when  6; "4 Random Enemies"
		when  7; "Single Ally"
		when  8; "All allies"
		when  9; "One Ally (Collapsed)"
		when 10; "All Allies (Collapsed)"
		when 11; "The User"
	end
end

def parseAvailability(a)
	return case a
		when 0; "Always"
		when 1; "Only in Battle"
		when 2; "Only from the Menu"
		when 3; "Never"
	end
end

def parseItemType(t)
	return case t
		when 0; "None"
		when 1; "Item"
		when 2; "Weapon"
		when 3; "Armor"
	end
end

def parseTurn(t1, t2)
	return "0" if t1 == 0 && t2 == 0
	s = ""
	s << "#{t1}" unless t1 == 0
	s << " + " if t1 > 0 && t2 > 0
	s << "#{t2} * X" unless t2 == 0
end

def parseRecover(r1, r2)
	return "0" if r1 == 0.0 && r2 == 0.0
	s = ""
	s << "#{(r1 * 100).to_i}%" unless r1 == 0.0
	s << " #{r2 > 0 ? "+" : "-"} " unless r2 == 0.0
	s << "#{r2.abs.to_i}" unless r2 == 0.0
end

def parseCondition(c, cp1, cp2)
	return case c
		when 0; "Always"
		when 1; "Turn Number: #{parseTurn(cp1, cp2)}"
		when 2; "MP: #{cp1}% ~ #{cp2}%"
		when 3; "MP: #{cp1}% ~ #{cp2}%"
		when 4; "State #{getState(cp1)}"
		when 5; "Party Level >= #{cp1}"
		when 6; "Switch #{getSwitch(cp1)} is ON"
	end
end

def parseSpan(s)
	return case s
		when 0; "Battle"
		when 1; "Turn"
		when 2; "Moment"
	end
end

def parseRestriction(r)
	return case r
		when 0; "None"
		when 1; "Attack an Enemy"
		when 2; "Attack an Enemy or Ally"
		when 3; "Attack an Ally"
		when 4; "Unable to Act"
	end
end

def parseAutoRelease(a)
	return case a
		when 0; "None"
		when 1; "End of Action"
		when 2; "End of Turn"
	end
end

def parseFlashScope(s)
	return case s
		when 0; "None"
		when 1; "Target"
		when 2; "Screen"
		when 3; "Clear Target"
	end
end

def parseTilesetMode(m)
	return case m
		when 0; "Field Type"
		when 1; "Area Type"
		when 2; "VX Compatible Type"
	end
end

def parseSpecialFlag(f)
	return case f
		when 0; "Automatic Combat"
		when 1; "Guard"
		when 2; "Substitute"
		when 3; "TP Carried Over"
	end
end

def parseExtEffect(e)
	return case e
		when 1; "Boss"
		when 2; "Instant Death"
		when 3; "Doesn't Disappear"
	end
end

def parsePartyAbility(a)
	return case a
		when 0; "Encounters Reduced by Half"
		when 1; "Encounters Disabled"
		when 2; "Suprise Attacks Disabled"
		when 3; "Preemptive Strike Rate Up"
		when 4; "Double Currency Acquisition Rate"
		when 5; "Double Item Acquisition Rate"
	end
end

# def updateItemFromJson(item, json)
# 	return unless json

# 	if item.respond_to?(:updateFromJson)
# 		item.updateFromJson(json)
# 	else
# 		item = json
# 	end

# 	return item
# end

def listUpdateFromJson(list, json)
	return unless json
	list.map!.with_index do | item, idx |
		item.updateFromJson(json[idx]) if json[idx]
		item
	end
end

def updateParametersFromJson(params, json)
	params.map!.with_index do | p, idx |
		# Check if p has a custom updateFromJson method, otherwise just update the value
		if p.respond_to?(:updateFromJson) && json[idx]
			p.updateFromJson(json[idx])
			p
		elsif json[idx]
			json[idx]
		else
			p
		end
	end
end
