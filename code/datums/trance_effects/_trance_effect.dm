/datum/trance_effect
	var/wordlist //This should be a string containing a regex pattern. If a message the mob hears matches this regex pattern, then it'll execute trigger()
	var/req_scale = 0 //The required scale for this trance effect to be considered at all. If the subject's scale is below this number, then the trance effect won't be considered.


//Trigger() is self-explanatory. Returning TRUE here will stop all other effects from being considered.
//Todo (maybe?) - add trance effect priority to the hypno subsystem
/datum/trance_effect/proc/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	return FALSE