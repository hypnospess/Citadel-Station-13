/datum/status_effect/hypno 
	id = "hypno"
	alert_type = null
	//examine_text TODO
	
	var/scale //deepness level from 100 (fully entranced) to 0 (fully awake)
	var/resist_amt //amount of resistance (increased by pressing resist.)
	var/deepener_mult //the multiplier for deepening effects
	var/delta_scale //amount by which to change the scale on the next tick
	var/relax_amt //amount of relaxation points
	var/relax_cap = 5 //max amount of relaxation points 
	var/scale_cap = 50 //highest scale without aids

	var/datum/mob/living/carbon/sub //the actual subject!
	var/datum/component/hyplistener/HL //the hyplistener
	var/desctext //description text for the sub

	/*
		hyplistener will be added on mob add, and delet when on mob remove
	*/
	