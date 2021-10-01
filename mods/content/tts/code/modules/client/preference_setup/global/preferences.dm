#define TTS_MAX_PITCH 350 // Higher values have no effect
#define TTS_MIN_PITCH 50 // Lower values have no effect
#define TTS_MAX_BREATHINESS 65 // Higher than this and it gets glitchy
#define TTS_MIN_BREATHINESS 0 // No negative values
#define TTS_MAX_SMOOTHNESS 40 // No effect beyond this point
#define TTS_MIN_SMOOTHNESS 20 // Ear pain below this

var/global/list/voice_presets = list("paul", "wendy")

/datum/preferences
	var/tts_volume = 70

	var/voice = "paul"
	var/voice_pitch = 100
	var/voice_breathiness = 0
	var/voice_smoothness = 20

/datum/client_preference/hear_tts
	description = "Hear TTS"
	key = "SOUND_TTS"
	options = list(PREF_YES, PREF_NO)
	default_value = PREF_YES

/datum/category_item/player_setup_item/player_global/settings/load_preferences(datum/pref_record_reader/R)
	. = ..()
	pref.tts_volume = R.read("tts_volume")

/datum/category_item/player_setup_item/player_global/settings/save_preferences(datum/pref_record_writer/W)
	. = ..()
	W.write("tts_volume", pref.tts_volume)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	. = ..()
	pref.tts_volume = sanitize_integer(pref.tts_volume, 1, 100, initial(pref.tts_volume))

/datum/category_item/player_setup_item/player_global/settings/content(mob/user)
	. = ..()
	. += "<table>"
	. += "<tr><td>Max TTS Volume:</td>"
	. += "<td><a href='?src=\ref[src];set_tts_vol=1'><b>[pref.tts_volume]</b></a></td>"
	. += "<td><a href='?src=\ref[src];reset_tts=tts_vol'>reset</a></td>"
	. += "</table>"

/datum/category_item/player_setup_item/player_global/settings/OnTopic(href, list/href_list, mob/user)
	if(href_list["set_tts_vol"])
		var/tts_volume_new = input(user, "Set Maximum TTS volume, between 1 and 100.", "Global Preference", pref.tts_volume) as num|null
		if(isnull(tts_volume_new) || (tts_volume_new< 1 || tts_volume_new > 100) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.tts_volume = tts_volume_new
		return TOPIC_REFRESH
	else if(href_list["reset_tts"])
		switch(href_list["reset_tts"])
			if("tts_vol")
				pref.tts_volume = initial(pref.tts_volume)
		return TOPIC_REFRESH
	return ..()

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)
	..()
	pref.voice = 				R.read("voice")
	pref.voice_pitch = 			R.read("voice_pitch")
	pref.voice_breathiness = 	R.read("voice_breathiness")
	pref.voice_smoothness = 	R.read("voice_smoothness")

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)
	..()
	W.write("voice", 				pref.voice)
	W.write("voice_pitch", 			pref.voice_pitch)
	W.write("voice_breathiness", 	pref.voice_breathiness)
	W.write("voice_smoothness", 	pref.voice_smoothness)

/datum/category_item/player_setup_item/physical/body/sanitize_character()
	..()
	pref.voice = pref.voice || pref.bodytype == "feminine" ? "wendy" : "paul"
	pref.voice_pitch = pref.voice_pitch || TTS_MIN_PITCH
	pref.voice_breathiness = pref.voice_breathiness || TTS_MIN_BREATHINESS
	pref.voice_smoothness = pref.voice_smoothness || TTS_MIN_SMOOTHNESS

/datum/category_item/player_setup_item/physical/body/content(mob/user)
	. = ..()
	. = list(.)
	. += "<h3>Voice</h3>"
	. += "<table width = '25%'>"
	. += "<tr>"
	. += "<td><b>Base Voice</b></td>"
	. += "<td><a href='?src=\ref[src];voice_base=1'>[pref.voice]</a></td>"
	. += "</tr>"
	. += "<tr>"
	. += "<td><b>Pitch</b></td>"
	. += "<td><a href='?src=\ref[src];voice_pitch=1'>[pref.voice_pitch]</a></td>"
	. += "</tr>"
	. += "<tr>"
	. += "<td><b>Breathiness</b></td>"
	. += "<td><a href='?src=\ref[src];voice_breathiness=1'>[pref.voice_breathiness]</a></td>"
	. += "</tr>"
	. += "<tr>"
	. += "<td><b>Smoothness</b></td>"
	. += "<td><a href='?src=\ref[src];voice_smoothness=1'>[pref.voice_smoothness]</a></td>"
	. += "</tr>"
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/body/OnTopic(href, list/href_list, mob/user)
	. = ..()
	if(href_list["voice_base"])
		var/selected_voice = input(user, "Select base voice", CHARACTER_PREFERENCE_INPUT_TITLE, pref.voice) as null|anything in global.voice_presets
		if(selected_voice && CanUseTopic(user))
			pref.voice = selected_voice
			return TOPIC_REFRESH
	else if(href_list["voice_pitch"])
		var/selected_pitch = input(user, "Select voice pitch, between [num2text(TTS_MIN_PITCH)] and [num2text(TTS_MAX_PITCH)]", CHARACTER_PREFERENCE_INPUT_TITLE, pref.voice_pitch)
		if(selected_pitch && CanUseTopic(user))
			pref.voice_pitch = Clamp(text2num(selected_pitch), TTS_MIN_PITCH, TTS_MAX_PITCH)
			return TOPIC_REFRESH
	else if(href_list["voice_breathiness"])
		var/selected_breathiness = input(user, "Select voice breathiness, between [num2text(TTS_MIN_BREATHINESS)] and [num2text(TTS_MAX_BREATHINESS)]", CHARACTER_PREFERENCE_INPUT_TITLE, pref.voice_breathiness)
		if(selected_breathiness && CanUseTopic(user))
			pref.voice_breathiness = Clamp(text2num(selected_breathiness), TTS_MIN_BREATHINESS, TTS_MAX_BREATHINESS)
			return TOPIC_REFRESH
	else if(href_list["voice_smoothness"])
		var/selected_smoothness = input(user, "Select voice smothness, between [num2text(TTS_MIN_SMOOTHNESS)] and [num2text(TTS_MAX_SMOOTHNESS)]", CHARACTER_PREFERENCE_INPUT_TITLE, pref.voice_smoothness)
		if(selected_smoothness && CanUseTopic(user))
			pref.voice_smoothness = Clamp(text2num(selected_smoothness), TTS_MIN_SMOOTHNESS, TTS_MAX_SMOOTHNESS)
			return TOPIC_REFRESH