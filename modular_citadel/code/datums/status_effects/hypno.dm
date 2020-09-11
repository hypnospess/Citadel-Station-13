/datum/status_effect/hypno 
	id = "hypno"
	alert_type = null
	//examine_text TODO
	
	var/scale //deepness level from 100 (awake) to 0 (fully entranced)
	var/resist_amt //amount of resistance (increased by pressing resist.)
	var/deepener_mult //the multiplier for deepening effects
	var/delta_scale //amount by which to change the scale on the next tick

	var/datum/mob/living/carbon/sub //the actual subject!
	var/desctext //description text for the sub

	/*
		We need some kind of "hypno listener" thing that is attached to this.
		It would look for hypno words being said nearby
		using mob.listen, i guess
		and parse them for hypno words!
	*/
	