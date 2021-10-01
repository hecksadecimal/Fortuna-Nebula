// Used to prevent people from injecting their own dectalk command symbols and causing ear damage
/proc/strip_phonemes(var/input)
	if(!input)
		return
	var/opentag = 1 //These store the position of [: and ] respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "\[:")
		closetag = findtext(input, "\]")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break
	return input

/mob/proc/texttospeech(var/text, listenrange as num, vol as num)
	var/lrange = (listenrange ? listenrange : 13)
	var/volume = (vol ? vol : 70)
	var/name2
	if (!name2)
		if(!src.ckey || src.ckey == "")
			name2 = "\ref[src]"
		else
			name2 = src.ckey
	spawn(0)
		var/list/voiceslist = list()
		var/prefix

		if(src.client)
			prefix = "\[:name [src.client.prefs.voice]\]\[:dv ap [src.client.prefs.voice_pitch]\]\[:dv br [src.client.prefs.voice_breathiness]\]\[:dv sm [src.client.prefs.voice_smoothness]\]"
		voiceslist["msg"] = prefix + strip_phonemes(text)
		voiceslist["ckey"] = name2
		var/params = list2params(voiceslist)

		text2file(params,"scripts/voicequeue.txt")

		//call("writevoice.dll", "writevoicetext")(params)

		shell("Speak.exe")

		if(fexists("scripts/voicequeue.txt"))
			fdel("scripts/voicequeue.txt")

	spawn(10)
		if(fexists("sound/playervoices/[name2].wav"))
			for(var/mob/M in range(lrange))
				if(M.get_preference_value(/datum/client_preference/hear_tts) == PREF_YES)
					volume = Clamp(volume, 1, M.client?.prefs.tts_volume)
					M.playsound_local(src.loc, "sound/playervoices/[name2].wav", volume)

/client/proc/texttospeech(var/text, var/clientkey)
	spawn(0)
		var/list/voiceslist = list()

		voiceslist["msg"] = text
		voiceslist["ckey"] = clientkey
		var/params = list2params(voiceslist)

		call("writevoice.dll", "writevoicetext")(params)