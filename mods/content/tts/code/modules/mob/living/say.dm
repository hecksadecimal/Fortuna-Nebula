/mob/living/say(message, decl/language/speaking, verb, alt_name, whispering)
	if(config.tts)
		if (speaking)
			if (speaking.flags & SIGNLANG)
				return

		if (whispering)
			src.texttospeech(message, 1, 5)
		else
			src.texttospeech(message)
	. = ..(message, speaking, verb, alt_name, whispering)