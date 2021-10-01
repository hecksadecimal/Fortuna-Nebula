/datum/configuration
	var/tts = 0		// Is Text To Speech enabled?

/datum/configuration/load(filename, type)
	. = ..(filename, type)

	// Doing another config check here to avoid nonmodular changes
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)
			switch(name)
				if("tts_enabled")
					config.tts = 1

