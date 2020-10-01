/datum/trance_effect
	var/wordlist
	var/req_scale = 0

/datum/trance_effect/proc/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	return FALSE