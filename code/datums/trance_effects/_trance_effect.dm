/datum/trance_effect
	var/wordlist
	var/req_scale = 0
	
	var/TEMP_outputstate //TODO - axe this var, and have all trance effects be handled directly via the trigger() proc. This is just a hack for compatibility with existing trance effects at the moment.

/datum/trance_effect/proc/trigger(mob/living/carbon/C, datum/status_effect/hypno/H)
	return TEMP_outputstate
