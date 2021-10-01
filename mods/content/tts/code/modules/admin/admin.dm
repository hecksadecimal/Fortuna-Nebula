/datum/admins/proc/toggletts()
	set category = "Server"
	set desc="Toggle TTS Globally"
	set name="Toggle TTS"
	config.tts = !config.tts
	log_admin("[usr.key] has toggled TTS [config.tts ? "on" : "off"] globally.")
	message_admins("<font color='red'>[usr.key] has toggled TTS [config.tts ? "on" : "off"] globally.</font>")
	to_world("<span class='bigwarning'>TTS has been globally [config.tts ? "enabled" : "disabled"].</span>")
	world.update_status()
	SSstatistics.add_field("admin_verb","TTS")

/client/add_admin_verbs()
	. = ..()
	if(holder)
		if(holder.rights & R_SERVER)
			verbs += /datum/admins/proc/toggletts
